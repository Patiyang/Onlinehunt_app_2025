import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabIndexBloc extends ChangeNotifier {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  setTabIndex(newIndex) {
    _tabIndex = newIndex;
    // print(_tabIndex);
    notifyListeners();
  }
}


class VideoTabIndexBloc extends ChangeNotifier {
  int _videoTabIndex = 0;
  int get tabIndex => _videoTabIndex;

  setTabIndex(newIndex) {
    _videoTabIndex = newIndex;
    // print(_videoTabIndex);
    notifyListeners();
  }
}