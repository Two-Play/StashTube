import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _currentPageIndex = 0;
int _index = 0;

enum PageState {
  swipeAnimation,
  jumpAnimation,
}

class MainModel {
  static get currentPageIndex => _currentPageIndex;
  static get index => _index;

  Future<bool> checkLogin() async {
    // if key url empty, go to login use readkey function
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('url') == null) {
      return false;
    }
    return true;
  }

  PageState barTapManagement(int index) {
    // calculate the difference between the current page and the next page
    int calc = _currentPageIndex - index;
    _currentPageIndex = index;
    _index = index;
    //HapticFeedback.mediumImpact();
    if (calc == 1 || calc == -1) {
      return PageState.swipeAnimation;
    } else {
      return PageState.jumpAnimation;
    }
  }

  void swipeManagement(int index) {
    _currentPageIndex = index;
    HapticFeedback.lightImpact();
  }
}