import 'package:fishing_calendar/presentation/main_page/main_page.dart';
import 'package:fishing_calendar/presentation/onboarding/onboarding_page.dart';
import 'package:fishing_calendar/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      themeMode: ThemeMode.light,
      home: OnboardingPage(),
    );
  }
}

