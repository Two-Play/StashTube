import 'package:flutter/cupertino.dart';

import '../../Model/screens/scenes_model.dart';
import '../../util/observable.dart';

class ScenesController extends Observable {
  final ScenesModel _scenesModel = ScenesModel();

  Future<void> fetchScenes() async{
    bool isSuccess = await _scenesModel.fetchScenes();
    //notifyListeners(ScenesEvents.fetchScenes);
    if(isSuccess) {
      notifyListeners(ScenesEvents.fetchScenesSuccess);
    } else {
      notifyListeners(ScenesEvents.fetchScenesFailed);
    }

  }
}