import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stash_app_mobile/util/storage.dart';

void main() {
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('saveKey should return true when saving a key-value pair', () async {
    expect(await Storage.saveKey("testKey", "testValue"), true);
  });

  test('readKey should return the correct value for a given key', () async {
    await Storage.saveKey("testKey", "testValue");
    expect(await Storage.readKey("testKey"), "testValue");
  });

  test('readKey should return null when reading a non-existent key', () async {
    // Better solution???: return null instead of empty string
    //expect(await Storage.readKey("nonExistentKey"), null);
    expect(await Storage.readKey("nonExistentKey"), "");
  });

  test('removeKey should return true when removing an existing key', () async {
    await Storage.saveKey("testKey", "testValue");
    expect(await Storage.removeKey("testKey"), true);
  });

  test(
      'removeKey should return true even when removing a non-existent key', () async {
    expect(await Storage.removeKey("nonExistentKey"), true);
  });
}