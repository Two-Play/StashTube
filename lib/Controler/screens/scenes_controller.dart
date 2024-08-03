import '../../Model/screens/scenes_model.dart';

class ScenesController {
  final ScenesModel _scenesModel = ScenesModel();

  void fetchScenes() {
    _scenesModel.fetchScenes();
  }
}