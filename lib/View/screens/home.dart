import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final String scenesQuery = """
    query 
    {
    sceneWall{
      title,
      date,
      rating100,
      files{
        duration,
        width
      }
      studio
      {
        name,
        url,
        image_path
      }
      paths {
        screenshot,
        stream,
        preview
        }
      performers{
        name,
        image_path
      }
    }
}
  """;

    return const Scaffold();
  }
}