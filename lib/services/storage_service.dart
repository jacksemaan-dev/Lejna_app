import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// A small helper around Firebase Storage. In a real implementation
/// error handling, metadata and path management would be added. This
/// service provides a method to upload a file and return its download URL.
class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage}) : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile({required File file, required String path}) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}