import 'package:flutter/material.dart';

class PPage with ChangeNotifier {
  int currentPage = 0;

  void changePage(int index) {
    if (currentPage == index) return;

    currentPage = index;

    notifyListeners();
  }
}
