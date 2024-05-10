
import '../Controler/controller.dart';

abstract class Observer {
  void update(ObseverEvent event);
}

class ObseverEvent {}

class Observable {
  List<Function> _listeners = [];

  void addListener(Function listener) {
    _listeners.add(listener);
  }

  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    _listeners.forEach((Function listener) {
      listener();
    });
  }
}