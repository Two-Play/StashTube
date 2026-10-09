import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/widgets/play_pause_icon.dart';

void main() {
  Widget app(bool playing, {bool reduceMotion = false}) => MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Scaffold(body: Center(child: PlayPauseIcon(playing: playing))),
        ),
      );

  double progress(WidgetTester tester) => tester.widget<AnimatedIcon>(find.byType(AnimatedIcon)).progress.value;

  testWidgets('morphs between play and pause', (tester) async {
    await tester.pumpWidget(app(false));
    expect(progress(tester), 0);

    await tester.pumpWidget(app(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(progress(tester), inExclusiveRange(0, 1), reason: 'in between while it morphs');
    await tester.pumpAndSettle();
    expect(progress(tester), 1);

    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    expect(progress(tester), 0);
  });

  testWidgets('switches at once with reduced motion', (tester) async {
    await tester.pumpWidget(app(false, reduceMotion: true));
    await tester.pumpWidget(app(true, reduceMotion: true));
    expect(progress(tester), 1);
  });
}
