import 'package:tackle_time/utils/services/onboarding_service.dart';
import 'package:tackle_time/presentation/main_page/main_page.dart';
import 'package:tackle_time/presentation/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCheck extends StatefulWidget {
  const OnboardingCheck({super.key});

  @override
  State<OnboardingCheck> createState() => _OnboardingCheckState();
}

class _OnboardingCheckState extends State<OnboardingCheck> {
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    _hasSeenOnboarding = await OnboardingService().hasSeenOnboarding();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _hasSeenOnboarding
        ? MainPage()  // Show the main home screen if onboarding is already seen
        : OnboardingPage();  // Show onboarding screen otherwise;
  }
}
