import 'package:flutter/cupertino.dart';

class NavigatorShorter {
  static void pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => page), (route) => false);
  }

  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page));
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  static void popAndPushNamed(BuildContext context, String routeName) {
    Navigator.of(context).popAndPushNamed(routeName);
  }

  static void pushNamed(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => page));
  }
}