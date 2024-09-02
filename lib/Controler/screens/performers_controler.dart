

import '../../Model/screens/performers_model.dart';

class PerformersControler {
  final PerformersModel _performersModel = PerformersModel();

  void fetchPerformers() {
    _performersModel.fetchPerformers();
  }
}