import 'package:stash_app_mobile/util/observable.dart';

final class HomeModel {
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

}