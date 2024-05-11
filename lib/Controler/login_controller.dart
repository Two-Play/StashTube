import 'package:flutter/cupertino.dart';
import 'package:stash_app_mobile/Model/screens/login_model.dart';

class LoginController {

  final LoginModel _loginModel = LoginModel();

  void handleLogin (final String url, BuildContext context) {
    _loginModel.handleLogin(url, context);
  }

}