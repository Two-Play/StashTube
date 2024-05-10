class LoginController {
  final String _username = 'admin';
  final String _password = 'admin';

  Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return username == _username && password == _password;
  }
}