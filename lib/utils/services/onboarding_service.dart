import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tackle_time/domain/onboarding_check.dart';

class OnboardingService {
  // Singleton pattern: Ensures a single instance of the service
  static final OnboardingService _instance = OnboardingService._internal();

  factory OnboardingService() {
    return _instance;
  }

  OnboardingService._internal();

  // Mark onboarding as seen
  Future<void> markOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  // Reset onboarding status
  Future<void> resetOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', false);
  }

  // Check if onboarding has been seen
  Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }
}
