import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/functions/storage.dart';
import 'package:stash_app_mobile/main.dart';

// create login page with wellcome title and login textfiel and button. save the url in the storage and navigate to the home page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

    Future<Map<String, dynamic>> sendGraphQLRequest(String request) async {
      final QueryOptions options = QueryOptions(
        document: gql(request),
      );

      final GraphQLClient _client = GraphQLClient(
        cache: GraphQLCache(),
        link: HttpLink('http://192.168.44.5:9999/graphql'),
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        print(result.exception.toString());
        return {};
      }

      print("HALLO Status: ${result.data!['systemStatus']['status']}");

      return result.data!;
    }


    Future<bool> isRequestStatusOk(final GraphQLClient client) async{

          const requestQuery = """
          {
            systemStatus
            {
              status
            }
          }
          """;

        // request to the server
        final statusQueryResult =
          QueryOptions(document: gql(requestQuery)
        );
          try {
            final QueryResult result = await client.query(statusQueryResult);
            if (result.hasException) {
              //print(result.exception.toString());
              return false;
            }
            return true;
          } catch (e) {
            //print(e);
            return false;
          }

        // final result = statusQueryResult.result;
        // if (result.hasException) {
        //   return false;
        // }
        //
        // if (result.data?['systemStatus']['status'] == 'ok') {
        //   return true;
        // }
        // return false;

    }


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
                  onPressed: () async {

                    if (_validateUrl(_urlController.text)) {
                      client.value =
                        GraphQLClient(
                          link: HttpLink("${_urlController.text}/graphql"),
                          // The default store is the InMemoryStore, which does NOT persist to disk
                          cache: GraphQLCache(store: HiveStore()),
                      );

                      //send request to the server
                      // execute firt if response status ok
                      if (await isRequestStatusOk(client.value)) {
                        //TODO: reset global video state to null

                        saveKey("url", _urlController.text);
                        Navigator.pushReplacementNamed(context, '/');
                      } else {
                        HapticFeedback.vibrate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            // red snackbar with invalid url message
                            backgroundColor: Colors.red,
                            content: Text('Invalid URL'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }


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
