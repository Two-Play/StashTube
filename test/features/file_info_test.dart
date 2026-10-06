import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/features/player/file_info.dart';

const _file = SceneFile(
  path: '/data/videos/holiday.mp4',
  size: 1288490189,
  format: 'mp4',
  width: 2560,
  height: 1440,
  videoCodec: 'h264',
  frameRate: 25,
  bitRate: 8500000,
);

void main() {
  testWidgets('shows a summary and expands to all details', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: FileInfoCard(files: [_file]))),
    ));
    expect(find.text('1440p · h264 · 1.2 GB · 8.5 Mbit/s'), findsOneWidget);
    expect(find.text('/data/videos/holiday.mp4'), findsNothing);

    await tester.tap(find.text('File info'));
    await tester.pump();
    expect(find.text('/data/videos/holiday.mp4'), findsOneWidget);
    expect(find.text('2560 × 1440'), findsOneWidget);
    expect(find.text('25 fps'), findsOneWidget);
    expect(find.text('Copy path'), findsOneWidget);
  });
}
