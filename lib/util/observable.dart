
import '../Controler/main_controller.dart';

abstract class Observer {
  void update(ObserverEvent event);
}

class ObserverEvent {}

enum NetworkEvents implements ObserverEvent {
  networkConnected,
  networkDisconnected,
  fetchFailed,
  fetchSuccess,
}

enum LoginEvents implements ObserverEvent {
  login,
  setTextfield,
  loginFailed,
  loginSuccess,
}

enum PerformersEvents implements ObserverEvent {
  fetchPerformers,
  fetchPerformersSuccess,
  fetchPerformersFailed,
}

enum ScenesEvents implements ObserverEvent {
  fetchScenes,
  fetchScenesSuccess,
  fetchScenesFailed, scrollListenerAdded,
}

enum SettingsEvents implements ObserverEvent {
  changeTheme,
}

enum MainEvents implements ObserverEvent {
  initFinished,
  loginChecked,
  loginSuccess,
  loginFailed,
  jumpToPage,
  swipeToPage,
  swiped,
  swipeAnimation,
  jumpAnimation,
  pageChanged
}

class Observable {
  final List<Observer> _listeners = [];
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