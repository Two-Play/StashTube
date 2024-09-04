

import '../../Model/screens/performers_model.dart';
import '../../util/observable.dart';

class PerformersController extends Observable {
  final PerformersModel _model = PerformersModel();

  void fetchPerformers()  {
    _model.fetchPerformers().then((isSuccess) {
      if (isSuccess) {
        notifyListeners(PerformersEvents.fetchPerformersSuccess);
      } else {
        notifyListeners(PerformersEvents.fetchPerformersFailed);
      }
    });
  }
}