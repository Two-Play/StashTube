import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/functions/storage.dart';
import 'package:stash_app_mobile/main.dart';

// create login page with wellcome title and login textfiel and button. save the url in the storage and navigate to the home page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _urlController = TextEditingController();
  // validate the url with regex
  bool _validateUrl(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }


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

                    if (_validateUrl(_urlController.text)) {
                      client.value =
                        GraphQLClient(
                          link: HttpLink("${_urlController.text}/graphql"),
                          // The default store is the InMemoryStore, which does NOT persist to disk
                          cache: GraphQLCache(store: HiveStore()),
                      );
                      saveKey("url", _urlController.text);
                      Navigator.pushReplacementNamed(context, '/');

                    } else {
                      HapticFeedback.vibrate();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // red snackbar with invalid url message
                          backgroundColor: Colors.red,
                          content: Text('Invalid URL'),
                        ),
                      );
                    }

                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),

      ),
    );
  }
}
