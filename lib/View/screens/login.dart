import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/Controler/screens/login_controller.dart';
import 'package:stash_app_mobile/util/observable.dart';

import '../../main.dart';


LoginController _loginController = LoginController();

// create login page with welcome title and login textfiel and button.
// Save the url in the storage and navigate to the home page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements Observer {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loginController.addListener(this);
    _loginController.setCurrentUrlToTextField(_urlController);
  }

  @override
  void dispose() {
    _loginController.removeListener(this);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                      hintText: 'Enter the URL',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _loginController.handleLogin(_urlController.text, context);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),

      ),
    );
  }

  @override
  void update(ObserverEvent event) {
    // TODO: implement update
    switch (event){
      // case ObserverEvent.loginSuccess:
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
      //   break;
      // case ObserverEvent.loginFailed:
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       backgroundColor: Colors.red,
      //       content: Text('Invalid URL'),
      //       duration: Duration(seconds: 1),
      //     ),
      //   );
      //   break;

      case LoginEvents.login:
        print("LoginEvent!!!!!!!");
        break;
      case LoginEvents.setTextfield:
        print("setTextfield event");
        break;
      case LoginEvents.loginFailed:
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            // red snackbar with invalid url message
            backgroundColor: Colors.red,
            content: Text('Invalid URL'),
          ),
        );
        break;
      default:
        print("default event");
        break;

    }
  }
}
