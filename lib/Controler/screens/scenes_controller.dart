import 'package:flutter/cupertino.dart';

import '../../Model/screens/scenes_model.dart';
import '../../util/observable.dart';

final class ScenesController extends Observable {
  final ScenesModel _model = ScenesModel();

  void fetchScenes() {
    _model.fetchScenes().then((isSuccess){
      //notifyListeners(ScenesEvents.fetchScenes);
      if(isSuccess) {
        notifyListeners(ScenesEvents.fetchScenesSuccess);
      } else {
        notifyListeners(ScenesEvents.fetchScenesFailed);
      }
    });
  }

  void scrollListener(ScrollController scrollController) {
    _model.scrollListener(scrollController);
    notifyListeners(ScenesEvents.scrollListenerAdded);
  }
}