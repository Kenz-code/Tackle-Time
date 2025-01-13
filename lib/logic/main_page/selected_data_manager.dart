import 'package:flutter/material.dart';

class SelectedDataManager {
  // Private constructor
  SelectedDataManager._internal();

  // Singleton instance
  static final SelectedDataManager _instance = SelectedDataManager._internal();

  // Getter to access the singleton instance
  factory SelectedDataManager() => _instance;

  // Selected day notifier
  final ValueNotifier<Map?> selectedDataNotifier = ValueNotifier(null);

  // Method to update the selected day
  void updateSelectedDay(Map data) {
    selectedDataNotifier.value = data;
  }
}