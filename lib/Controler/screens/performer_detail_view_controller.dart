import 'package:stash_app_mobile/util/observable.dart';
import '../../Model/screens/performer_detail_view_model.dart';

final class PerformerDetailViewController extends Observable {
  PerformerDetailViewController(this.performerId) {
    _model = PerformerDetailViewModel(performerId: performerId.toString());
  }

  final int performerId;
  late final PerformerDetailViewModel _model;

  Future<void> fetchPerformer() async {
    bool isSuccess = await _model.fetchPerformer();
      if (isSuccess) {
        notifyListeners(NetworkEvents.fetchSuccess);
      } else {
        notifyListeners(NetworkEvents.fetchFailed);
      }
  }
}