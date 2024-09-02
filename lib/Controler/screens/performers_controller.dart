

import '../../Model/screens/performers_model.dart';
import '../../util/observable.dart';

class PerformersController extends Observable {
  final PerformersModel _performersModel = PerformersModel();

  Future<void> fetchPerformers() async {
    bool isSuccess = await _performersModel.fetchPerformers();
    if (isSuccess) {
      notifyListeners(PerformersEvents.fetchPerformersSuccess);
    } else {
      notifyListeners(PerformersEvents.fetchPerformersFailed);
    }
  }
}