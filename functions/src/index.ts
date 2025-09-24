import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import PDFDocument from 'pdfkit';
import * as QRCode from 'qrcode';
import archiver from 'archiver';
import * as stream from 'stream';
import moment from 'moment';

// ---------------------------------------------------------------------
// Admin bootstrap
// ---------------------------------------------------------------------
if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();
const storage = admin.storage().bucket();

// ---------------------------------------------------------------------
// Auth + membership guards (use in EVERY callable)
// ---------------------------------------------------------------------
function requireAuth(context: functions.https.CallableContext): string {
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  return uid;
}

async function assertBuildingMember(
  dbRef: FirebaseFirestore.Firestore,
  buildingId: string,
  uid: string
): Promise<void> {
  const memSnap = await dbRef.doc(`buildings/${buildingId}/members/${uid}`).get();
  if (!memSnap.exists) {
    throw new functions.https.HttpsError('permission-denied', 'Not a member of this building');
  }
}

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------
async function makePdfBuffer(
  build: (doc: InstanceType<typeof PDFDocument>) => void | Promise<void>
): Promise<Buffer> {
  return await new Promise<Buffer>((resolve, reject) => {
    const doc = new PDFDocument();
    const chunks: Buffer[] = [];
    doc.on('data', (d) => chunks.push(d as Buffer));
    doc.on('error', reject);
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    Promise.resolve(build(doc)).then(() => doc.end()).catch(reject);
  });
}

async function dataUrlToPngBuffer(dataUrl: string): Promise<Buffer> {
  const base64 = dataUrl.split(',')[1] ?? '';
  return Buffer.from(base64, 'base64');
}

async function makeZipBuffer(populate: (a: archiver.Archiver) => void | Promise<void>): Promise<Buffer> {
  return await new Promise<Buffer>((resolve, reject) => {
    const pass = new stream.PassThrough();
    const chunks: Buffer[] = [];
    pass.on('data', (c) => chunks.push(c as Buffer));
    pass.on('end', () => resolve(Buffer.concat(chunks)));

    const a = archiver('zip', { zlib: { level: 9 } });
    a.on('error', reject);
    a.pipe(pass);

    Promise.resolve(populate(a))
      .then(() => a.finalize())
      .catch(reject);
  });
}

// ---------------------------------------------------------------------
// Callables
// ---------------------------------------------------------------------

/**
 * generateReceipt(paymentId)
 * Creates a PDF receipt for the given payment under a building.
 * Uploads to: buildings/{buildingId}/receipts/{receiptNo}.pdf
 * Returns: signed URL
 */
export const generateReceipt = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const buildingId: string = data?.buildingId;
  const paymentId: string = data?.paymentId;
  if (!buildingId || !paymentId) {
    throw new functions.https.HttpsError('invalid-argument', 'buildingId and paymentId are required');
  }
  await assertBuildingMember(db, buildingId, uid);

  const paymentSnap = await db.doc(`buildings/${buildingId}/payments/${paymentId}`).get();
  if (!paymentSnap.exists) throw new functions.https.HttpsError('not-found', 'Payment not found');
  const payment = paymentSnap.data()!;
  const receiptNo: string = payment.receiptNo ?? paymentId;
  const verifyUrl = `https://lejna.app/verifyReceipt?receiptNo=${receiptNo}`;

  const qrDataUrl = await QRCode.toDataURL(verifyUrl);
  const qrPng = await dataUrlToPngBuffer(qrDataUrl);

  const pdfBuf = await makePdfBuffer((doc) => {
    doc.fontSize(20).text('Receipt', { align: 'center' }).moveDown();
    doc.fontSize(12).text(`Receipt #: ${receiptNo}`);
    doc.text(`Payment ID: ${paymentId}`);
    doc.text(`Amount: ${payment.amount}`);
    if (payment.unitId) doc.text(`Unit: ${payment.unitId}`);
    doc.moveDown();
    doc.image(qrPng, { fit: [120, 120], align: 'center' });
  });

  const filePath = `buildings/${buildingId}/receipts/${receiptNo}.pdf`;
  const file = storage.file(filePath);
  await file.save(pdfBuf, { contentType: 'application/pdf' });
  const [url] = await file.getSignedUrl({ action: 'read', expires: '2030-03-01T00:00:00Z' });
  return { url };
});

/**
 * generateMonthlyStatement(buildingId, period: YYYY-MM)
 * Creates a simple monthly statement PDF and uploads to:
 * buildings/{buildingId}/statements/{period}.pdf
 */
export const generateMonthlyStatement = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const buildingId: string = data?.buildingId;
  const period: string = data?.period;
  if (!buildingId || !period) {
    throw new functions.https.HttpsError('invalid-argument', 'buildingId and period are required');
  }
  await assertBuildingMember(db, buildingId, uid);

  const pdfBuf = await makePdfBuffer((doc) => {
    doc.fontSize(20).text(`Monthly Statement for ${period}`, { align: 'center' }).moveDown();
    doc.fontSize(12).text(`Building: ${buildingId}`);
    doc.moveDown().text('This is a placeholder statement. Replace with real aggregation.');
  });

  const filePath = `buildings/${buildingId}/statements/${period}.pdf`;
  const file = storage.file(filePath);
  await file.save(pdfBuf, { contentType: 'application/pdf' });
  const [url] = await file.getSignedUrl({ action: 'read', expires: '2030-03-01T00:00:00Z' });
  return { url };
});

/**
 * exportAll(buildingId)
 * Zips basic artifacts and uploads to:
 * buildings/{buildingId}/exports/{buildingId}_export.zip
 */
export const exportAll = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const buildingId: string = data?.buildingId;
  if (!buildingId) {
    throw new functions.https.HttpsError('invalid-argument', 'buildingId is required');
  }
  await assertBuildingMember(db, buildingId, uid);

  const zipBuf = await makeZipBuffer((a) => {
    // Minimal placeholder contents; wire real Storage reads as needed.
    a.append('unitLabel,sharePerMille\nApt1,125\n', { name: 'bylaw.csv' });
    a.append('See receipts folder in Storage for PDFs.\n', { name: 'receipts/readme.txt' });
    a.append(`Export generated at ${new Date().toISOString()}\n`, { name: 'meta.txt' });
  });

  const name = `${buildingId}_export.zip`;
  const filePath = `buildings/${buildingId}/exports/${name}`;
  const file = storage.file(filePath);
  await file.save(zipBuf, { contentType: 'application/zip' });
  const [url] = await file.getSignedUrl({ action: 'read', expires: '2030-03-01T00:00:00Z' });
  return { url };
});

/**
 * applyReferral(referralCode, newBuildingId)
 * Credits the referrer and referee; enforces a 12-month cycle and caps free months.
 */
export const applyReferral = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const referralCode: string = data?.referralCode;
  const newBuildingId: string = data?.newBuildingId;
  if (!referralCode || !newBuildingId) {
    throw new functions.https.HttpsError('invalid-argument', 'referralCode and newBuildingId are required');
  }

  // Find referrer building
  const q = await db.collection('buildings').where('referralCode', '==', referralCode).limit(1).get();
  if (q.empty) throw new functions.https.HttpsError('not-found', 'Referrer not found');
  const referrerId = q.docs[0].id;

  // Caller must be a member of the referrer building
  await assertBuildingMember(db, referrerId, uid);

  const result = await db.runTransaction(async (txn) => {
    const referrerRef = db.doc(`buildings/${referrerId}`);
    const refereeRef = db.doc(`buildings/${newBuildingId}`);

    const referrerData = (await txn.get(referrerRef)).data() ?? {};
    const now = moment();
    const cycleStart = referrerData.cycleStart ? moment(referrerData.cycleStart.toDate()) : now.clone();

    let freeMonths: number = referrerData.freeMonths || 0;
    let referralsCount: number = referrerData.referralsCount || 0;

    // Reset cycle if > 12 months
    if (now.diff(cycleStart, 'months') >= 12) {
      freeMonths = 0;
      referralsCount = 0;
    }

    referralsCount += 1;
    let credit = 1;
    if (referralsCount % 6 === 0) credit = 2; // bonus on every 6th

    freeMonths = Math.min(freeMonths + credit, 8);

    txn.set(refereeRef, { freeMonths: 1 }, { merge: true }); // referee gets +1
    txn.set(
      referrerRef,
      {
        freeMonths,
        referralsCount,
        cycleStart: cycleStart.toDate(),
      },
      { merge: true }
    );

    return { freeMonths, referralsCount, credit };
  });

  return result;
});

/**
 * notifyOnNewCharge(buildingId)
 * Sends a push notification to topic `building_{buildingId}`.
 */
export const notifyOnNewCharge = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const buildingId: string = data?.buildingId;
  if (!buildingId) throw new functions.https.HttpsError('invalid-argument', 'buildingId is required');
  await assertBuildingMember(db, buildingId, uid);

  const message = {
    notification: { title: 'New Charge', body: 'A new charge has been published for your building.' },
    topic: `building_${buildingId}`,
  };
  await admin.messaging().send(message);
  return { success: true };
});

/**
 * reminderDues(buildingId)
 * Sends a generic dues reminder to topic `building_{buildingId}`.
 */
export const reminderDues = functions.https.onCall(async (data, context) => {
  const uid = requireAuth(context);
  const buildingId: string = data?.buildingId;
  if (!buildingId) throw new functions.https.HttpsError('invalid-argument', 'buildingId is required');
  await assertBuildingMember(db, buildingId, uid);

  const message = {
    notification: { title: 'Dues Reminder', body: 'You have outstanding dues. Please pay promptly.' },
    topic: `building_${buildingId}`,
  };
  await admin.messaging().send(message);
  return { success: true };
});
