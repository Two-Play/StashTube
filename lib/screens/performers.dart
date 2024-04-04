import 'package:flutter/material.dart';

class Performers {
  final String name;
  final String image;
  final String bio;


  const Performers({
    required this.name,
    required this.image,
    required this.bio,
  });

}

class PerformersPage extends StatelessWidget {
  const PerformersPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}