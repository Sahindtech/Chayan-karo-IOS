import 'package:flutter/material.dart';

class SaathiController extends ChangeNotifier {
  int _selectedIndex = 0;
  
  int get selectedIndex => _selectedIndex;
  
  // Empty list - no dummy data
  List<Map<String, dynamic>> get saathiList => [];

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
