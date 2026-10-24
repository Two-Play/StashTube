import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/channel/channel_tabs.dart';

/// Swiping between a channel's tabs (CH-2): each tab is its own scroll view
/// with a horizontal shelf, which keeps its own drags.
void main() {
  Future<void> pumpTabs(WidgetTester tester, {bool reducedMotion = false}) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: const Size(400, 800), disableAnimations: reducedMotion),
        child: Scaffold(
          body: ChannelTabsView(
            tabs: const [ChannelTab.videos, ChannelTab.images, ChannelTab.about],
            header: const SizedBox(height: 100, child: Text('header')),
            builder: (context, tab, headerSlivers) => CustomScrollView(
              slivers: [
                ...headerSlivers,
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView(
                      key: ValueKey('shelf ${tab.name}'),
                      scrollDirection: Axis.horizontal,
                      children: [for (var i = 0; i < 20; i++) SizedBox(width: 100, child: Text('${tab.name} $i'))],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 300, child: Center(child: Text('content ${tab.name}')))),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  bool shows(String tab) => find.text('content $tab').evaluate().isNotEmpty;

  testWidgets('a fling to the left shows the next tab, to the right the previous one', (tester) async {
    await pumpTabs(tester);
    expect(shows('videos'), isTrue);

    await tester.fling(find.text('content videos'), const Offset(-200, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('images'), isTrue);
    expect(shows('videos'), isFalse);

    await tester.fling(find.text('content images'), const Offset(-200, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('about'), isTrue);

    // No tab after the last one.
    await tester.fling(find.text('content about'), const Offset(-200, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('about'), isTrue);

    await tester.fling(find.text('content about'), const Offset(200, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('images'), isTrue);
  });

  testWidgets('a slow, long drag switches; a short one springs back', (tester) async {
    await pumpTabs(tester);
    await tester.timedDrag(find.text('content videos'), const Offset(-40, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(shows('videos'), isTrue);

    await tester.timedDrag(find.text('content videos'), const Offset(-150, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(shows('images'), isTrue);
  });

  testWidgets('the shelf keeps its horizontal drags', (tester) async {
    await pumpTabs(tester);
    await tester.fling(find.text('videos 1'), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('videos'), isTrue);
    expect(find.text('videos 0'), findsNothing, reason: 'the shelf scrolled instead');
  });

  testWidgets('vertical scrolling stays vertical', (tester) async {
    await pumpTabs(tester);
    await tester.fling(find.text('content videos'), const Offset(-20, -200), 1000);
    await tester.pumpAndSettle();
    expect(shows('videos'), isTrue);
  });

  testWidgets("drags from the screen's edge are left to the back gesture", (tester) async {
    await pumpTabs(tester);
    final y = tester.getCenter(find.text('content videos')).dy;
    await tester.flingFrom(Offset(5, y), const Offset(250, 0), 1000);
    await tester.pumpAndSettle();
    await tester.fling(find.text('content videos'), const Offset(-200, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('images'), isTrue);
    await tester.flingFrom(Offset(5, y), const Offset(250, 0), 1000);
    await tester.pumpAndSettle();
    expect(shows('images'), isTrue, reason: 'the edge swipe did not switch back');
  });

  testWidgets('with reduced motion the tab switches without sliding', (tester) async {
    await pumpTabs(tester, reducedMotion: true);
    await tester.fling(find.text('content videos'), const Offset(-200, 0), 1000);
    await tester.pump();
    expect(shows('images'), isTrue);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
