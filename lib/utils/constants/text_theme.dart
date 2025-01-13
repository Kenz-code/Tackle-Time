import 'package:flutter/material.dart';
import 'package:fishing_calendar/utils/constants/open_color.dart';

class AppTextTheme {

  AppTextTheme._();

  static TextTheme theme = TextTheme(
    displayLarge: const TextStyle().copyWith(fontSize: 48, fontWeight: FontWeight.w700),
    displayMedium: const TextStyle().copyWith(fontSize: 36, fontWeight: FontWeight.w700),
    displaySmall: const TextStyle().copyWith(fontSize: 36, fontWeight: FontWeight.w700),

    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: const TextStyle().copyWith(fontSize: 28, fontWeight: FontWeight.w700),
    headlineSmall: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700),

    titleLarge: const TextStyle().copyWith(fontSize: 20, fontWeight: FontWeight.w700),
    titleMedium: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w700),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400),

    labelLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w500),

  );

}