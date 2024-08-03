
import 'package:stash_app_mobile/util/observable.dart';

import '../util/observable.dart';

class Controller extends Observable {
  String _name = 'John Doe';

  String get name => _name;

  // set name(String value) {
  //   _name = value;
  //   notifyListeners();
  // }
}

// enum ControllerEvents implements ObserverEvent {
//   nameChanged,
// }