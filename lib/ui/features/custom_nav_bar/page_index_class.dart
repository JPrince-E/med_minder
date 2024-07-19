
import 'package:flutter/material.dart';

class CurrentPage with ChangeNotifier {
  int currentPageIndex = 0;

  void setCurrentPageIndex(int pageIndex) {
    currentPageIndex = pageIndex;
    notifyListeners();
  }
}
