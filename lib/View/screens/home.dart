import 'package:flutter/material.dart';
import 'package:stash_app_mobile/util/observable.dart';

final class HomePage extends StatelessWidget implements Observer {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    return const Scaffold();
  }

  @override
  void update(ObserverEvent event) {
    // TODO: implement update
  }
}