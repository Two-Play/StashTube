
import 'package:stash_app_mobile/Model/main_model.dart';
import 'package:stash_app_mobile/util/observable.dart';

import '../util/observable.dart';

final class MainController extends Observable {
  final MainModel _model = MainModel();

  void init() {
    notifyListeners(MainEvents.initFinished);

  }

  void checkLogin() {
    //notifyListeners(MainEvents.loginChecked);
    _model.checkLogin().then((isSuccess) {
      if (isSuccess) {
        notifyListeners(MainEvents.loginSuccess);
      } else {
        notifyListeners(MainEvents.loginFailed);
      }
    });
  }

  void barTapManagement(int index) {
    checkLogin(); // check if user is logged in before changing page
    bool isSwipe = _model.barTapManagement(index) == PageState.swipeAnimation;
    if (isSwipe) {
      notifyListeners(MainEvents.swipeAnimation);
    } else {
      notifyListeners(MainEvents.jumpAnimation);
    }
    notifyListeners(MainEvents.pageChanged);
  }

  void swipeManagement(int index) {
    checkLogin(); // check if user is logged in before changing page
    _model.swipeManagement(index);
    //notifyListeners(MainEvents.Swiped);
    notifyListeners(MainEvents.pageChanged);
  }
}