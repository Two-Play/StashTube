import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/Controler/login_controller.dart';
import 'package:stash_app_mobile/util/observable.dart';


LoginController _loginController = LoginController();

// create login page with wellcome title and login textfiel and button. save the url in the storage and navigate to the home page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements Observer{
  final TextEditingController _urlController = TextEditingController();
  // validate the url with regex



  @override
  void initState(){
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      String? value = prefs.getString('url');
      // Do something with value
      _urlController.text = value ?? "";
    });


  }

  @override
  void dispose() {
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
  void update(ObseverEvent event) {
    // TODO: implement update
  }
}
