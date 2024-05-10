

abstract class Observable {
  List<Function> _listeners = [];

  void addListener(Function listener) {
    _listeners.add(listener);
  }

  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (Function listener in _listeners) {
      listener();
    }
  }
}