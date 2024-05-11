
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/util/validators.dart';

void main() {
  test('Test email validator functions', () {
    expect(Validators.emailValidator("test@test.com"), true);
    expect(Validators.emailValidator("test.com"), false);
  });

  test('Test password validator functions', () {
    expect(Validators.passwordValidator("password"), true);
    expect(Validators.passwordValidator("pass"), false);
  });

  test('Test url validator functions', () {
    expect(Validators.validateUrl("https://www.google.com"), true);
    expect(Validators.validateUrl("www.google.com"), false);
  });
}