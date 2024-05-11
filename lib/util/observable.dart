
import '../Controler/controller.dart';

abstract class Observer {
  void update(ObseverEvent event);
}

class ObseverEvent {}

class Observable {
  List<Observer> _listeners = [];
  List<Observer> get listeners => _listeners;

  void addListener(Observer observer) {
    _listeners.add(observer);
  }

  void removeListener(Observer observer) {
    _listeners.remove(observer);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener.update(ObseverEvent());
    }
  }
}