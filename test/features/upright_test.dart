import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';

void main() {
  test('gravity tells an upright phone from a sideways or flat one', () {
    expect(isHeldUpright(0.5, 9.7), isTrue);
    expect(isHeldUpright(-1, -9.5), isTrue, reason: 'upside down counts too');
    expect(isHeldUpright(9.6, 1), isFalse, reason: 'sideways');
    expect(isHeldUpright(6, 7.5), isFalse, reason: 'tilted half way');
    expect(isHeldUpright(0.2, 0.3), isFalse, reason: 'lying flat');
  });
}
