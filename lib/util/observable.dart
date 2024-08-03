
import '../Controler/controller.dart';

abstract class Observer {
  void update(ObserverEvent event);
}

class ObserverEvent {}

enum LoginEvents implements ObserverEvent {
  login,
  setTextfield,
  loginFailed,
  loginSuccess,
}

class Observable {
  List<Observer> _listeners = [];
  List<Observer> get listeners => _listeners;

  void addListener(Observer observer) {
    _listeners.add(observer);
  }

  void removeListener(Observer observer) {
    _listeners.remove(observer);
  }

  void notifyListeners(ObserverEvent event) {
    for (var listener in _listeners) {
      listener.update(event);
    }
  }
}