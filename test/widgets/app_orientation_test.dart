import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/app_orientation.dart';

void main() {
  setUp(AppOrientation.reset);
  tearDown(AppOrientation.reset);

  const portrait = [DeviceOrientation.portraitUp];

  test('a phone stays portrait; a tablet turns everywhere', () async {
    await AppOrientation.setPhone(true);
    expect(AppOrientation.allowed, portrait);
    await AppOrientation.setPhone(false);
    expect(AppOrientation.allowed, isEmpty);
  });

  test('the fullscreen turns a phone until it hands back', () async {
    await AppOrientation.setPhone(true);
    const landscape = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];
    await AppOrientation.turnTo(landscape);
    expect(AppOrientation.allowed, landscape);

    await AppOrientation.turnTo(null);
    expect(AppOrientation.allowed, portrait);
  });

  for (final (size, phone) in [(const Size(390, 844), true), (const Size(844, 390), true), (const Size(1024, 768), false)]) {
    testWidgets('a ${size.width.round()}×${size.height.round()} window is ${phone ? 'a phone' : 'a tablet'}',
        (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: const AppOrientationScope(child: SizedBox()),
        ),
      ));
      expect(AppOrientation.allowed, phone ? portrait : isEmpty);
    });
  }
}
