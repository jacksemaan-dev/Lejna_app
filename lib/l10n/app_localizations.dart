import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A very small i18n implementation used for the Lejne MVP.
///
/// This class avoids the need to run `flutter gen-l10n` by providing a
/// hand‑rolled [LocalizationsDelegate] and translation lookup table. Only
/// a handful of keys are defined—enough to demonstrate RTL support and
/// allow the app shell to switch between English and Arabic. For a
/// production app you should replace this with the official intl
/// workflow.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// List of supported locales. Add any new language codes here.
  static const supportedLocales = [Locale('en'), Locale('ar')];

  /// Factory helper to look up the localization in the widget tree.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// The lookup table containing key/value pairs for each language.
  /// When adding new strings please ensure a corresponding entry exists
  /// in both the English and Arabic maps.
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Lejne',
      'dashboard': 'Dashboard',
      'invoices': 'Invoices',
      'receipts': 'Receipts',
      'reports': 'Reports',
      'referrals': 'Referrals',
      'adminDashboard': 'Admin Dashboard',
      'createCharge': 'Create Charge',
      'addPayment': 'Add Payment',
      'addExpense': 'Add Expense',
      'units': 'Units',
      'members': 'Members',
      'settings': 'Settings',
      'login': 'Login',
      'logout': 'Logout',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      // New keys for settings and legal pages
      'legal': 'Legal',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'lastUpdated': 'Last updated: 2025-09-23',
      'visibilityMode': 'Visibility Mode',
      'fullTransparency': 'Full transparency (per-unit dues visible)',
      'aggregated': 'Aggregated (totals only)',
    },
    'ar': {
      'appTitle': 'ليجنه',
      'dashboard': 'لوحة القيادة',
      'invoices': 'الفواتير',
      'receipts': 'الإيصالات',
      'reports': 'التقارير',
      'referrals': 'الإحالات',
      'adminDashboard': 'لوحة المشرف',
      'createCharge': 'إنشاء رسم',
      'addPayment': 'إضافة دفع',
      'addExpense': 'إضافة مصاريف',
      'units': 'الوحدات',
      'members': 'الأعضاء',
      'settings': 'الإعدادات',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      // New keys for settings and legal pages
      'legal': 'قانوني',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfService': 'شروط الخدمة',
      'lastUpdated': 'آخر تحديث: 23-09-2025',
      'visibilityMode': 'وضع الشفافية',
      'fullTransparency': 'شفافية كاملة (عرض المستحقات لكل وحدة)',
      'aggregated': 'إجمالي (الاجماليات فقط)',
    },
  };

  /// Primary translation function. Returns the localized string for the
  /// given key or the key itself if no translation is found. This makes
  /// development smoother because typos will surface in the UI instead of
  /// silently falling back.
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  /// A convenience property to determine if the current locale is RTL.
  bool get isRtl => locale.languageCode == 'ar';

  /// The delegate is responsible for instantiating [AppLocalizations]
  /// objects when the locale changes.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}