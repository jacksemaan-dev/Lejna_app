import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider that holds the current [Locale]. The initial locale
/// defaults to English but can be updated by calling `setLocale` on the
/// [LocaleNotifier]. UI widgets should watch this provider to update
/// themselves when the locale changes.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(Locale locale) {
    if (locale == state) return;
    state = locale;
  }
}