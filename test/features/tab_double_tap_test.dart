import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';

void main() {
  test('two taps on the same tab in time are a double tap', () {
    final taps = TabDoubleTap();
    final t = DateTime(2026);
    expect(taps.tap(AppTab.you, t), isFalse);
    expect(taps.tap(AppTab.you, t.add(const Duration(milliseconds: 200))), isTrue);
    expect(taps.tap(AppTab.you, t.add(const Duration(milliseconds: 300))), isFalse, reason: 'a third tap starts anew');
    expect(taps.tap(AppTab.you, t.add(const Duration(seconds: 2))), isFalse, reason: 'too late');
    expect(taps.tap(AppTab.home, t.add(const Duration(milliseconds: 2100))), isFalse, reason: 'another tab');
  });
}
