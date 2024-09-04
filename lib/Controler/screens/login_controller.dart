import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stash_app_mobile/Model/screens/login_model.dart';
import 'package:stash_app_mobile/util/observable.dart';

final class LoginController extends Observable {

  final LoginModel _model = LoginModel();

  void handleLogin (final String url, WidgetRef ref) {
    _model.loginSuccess(url, ref).then((isSuccess) {
      if (isSuccess) {
        notifyListeners(LoginEvents.loginSuccess);
      } else {
        notifyListeners(LoginEvents.loginFailed);
      }
    });
  }

  void setCurrentUrlToTextField(final TextEditingController controller) {
    _model.setCurrentUrlToTextField(controller);
    notifyListeners(LoginEvents.setTextfield);
  }

}