
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/util/observable.dart';

class TestClass extends Observer {
  int updated = 0;

  @override
  void update(ObserverEvent event) {
    updated++;
  }
}

void main() {

  final Observable observable = Observable();
  final TestClass observer = TestClass();

  setUp(() {

  });

  test('Test observable add function', () {
    observable.addListener(observer);
    expect(observable.listeners.length, 1);
  });

  test('Test observable remove function', () {
    observable.removeListener(observer);
    expect(observable.listeners.length, 0);
  });

  test('Test observable notify function', () {
    observable.addListener(observer);
    observable.notifyListeners(LoginEvents.login);
    expect(observer.updated, 1);
  });
}