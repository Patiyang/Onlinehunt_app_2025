import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomNavBloc extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
