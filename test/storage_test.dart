import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stash_app_mobile/util/storage.dart';

void main() {

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('Test storage functions', () async {
    // save key
    expect(await saveKey("key", "value"), true);
    // read key
    expect(await readKey("key"), "value");
    // remove key
    expect(await removeKey("key"), true);
  });
}