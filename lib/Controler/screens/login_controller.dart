import 'package:flutter/cupertino.dart';
import 'package:stash_app_mobile/Model/screens/login_model.dart';
import 'package:stash_app_mobile/util/observable.dart';

class LoginController extends Observable {

  final LoginModel _loginModel = LoginModel();

  void handleLogin (final String url, BuildContext context) {
    _loginModel.handleLogin(url, context);
    notifyListeners(LoginEvents.login);
  }

  void setCurrentUrlToTextField(final TextEditingController controller) {
    _loginModel.setCurrentUrlToTextField(controller);
    notifyListeners(LoginEvents.setTextfield);
  }

}