import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/search/search_completions.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';

void main() {
  group('matchRank', () {
    test('starts with, word start, contains, all words', () {
      expect(matchRank('Anna Bell', 'an'), 0);
      expect(matchRank('anna bell', 'AN'), 0);
      expect(matchRank('Big Ann', 'an'), 1);
      expect(matchRank('Mary-Ann', 'ann'), 1);
      expect(matchRank('Joanna', 'an'), 2);
      expect(matchRank('Bell, Anna', 'anna bell'), 3);
      expect(matchRank('Zoe', 'an'), isNull);
      expect(matchRank('Anything', '  '), isNull);
    });
  });

  group('rankCompletions', () {
    const performer = CompletionKind.performer;
    const tag = CompletionKind.tag;
    const scene = CompletionKind.scene;

    test('orders by rank, then kind, then server order', () {
      final ranked = rankCompletions('an', const [
        Completion('Joanna', performer, id: '1'),
        Completion('Big Ann', performer, id: '2'),
        Completion('Anna', performer, id: '3'),
        Completion('Banana', scene),
        Completion('Animals', tag, id: 't'),
        Completion('Andes trip', scene),
      ]);
      expect([for (final c in ranked) c.text], ['Anna', 'Animals', 'Andes trip', 'Big Ann', 'Joanna', 'Banana']);
    });

    test('drops texts that do not contain the typed text', () {
      final ranked = rankCompletions('an', const [Completion('Zoe', performer, id: 'z')]);
      expect(ranked, isEmpty);
    });

    test('de-duplicates case-insensitively, also against the history rows', () {
      final ranked = rankCompletions(
        'an',
        const [
          Completion('Anna', performer, id: '1'),
          Completion('ANNA', tag, id: 't'),
          Completion('Andes', scene),
        ],
        exclude: ['andes'],
      );
      expect([for (final c in ranked) c.text], ['Anna']);
    });

    test('limits the total and each kind', () {
      final many = [for (var i = 0; i < 10; i++) Completion('Anna $i', performer, id: '$i')];
      final ranked = rankCompletions('an', [...many, const Completion('Animals', tag, id: 't')], limit: 5, perKind: 4);
      expect([for (final c in ranked) c.text], ['Anna 0', 'Anna 1', 'Anna 2', 'Anna 3', 'Animals']);
    });
  });

  test('history completions: matching entries, starts-with first, then the most recent', () {
    final history = historyCompletions(['band', 'zebra', 'animal', 'anna'], 'an');
    expect([for (final c in history) c.text], ['animal', 'anna', 'band']);
    expect(history.every((c) => c.kind == CompletionKind.history), isTrue);
    expect(historyCompletions(['a1', 'a2', 'a3', 'a4'], 'a', limit: 2).length, 2);
  });

  group('highlighting', () {
    List<(String, bool)> spans(String text, String typed) => [
          for (final s in highlightedSpan(text, typed).children!.cast<TextSpan>())
            (s.text!, s.style?.fontWeight == FontWeight.w700),
        ];

    test('bolds the typed part, the rest stays normal', () {
      expect(highlightedSpan('Anna', 'an').style?.fontWeight, FontWeight.w400);
      expect(spans('Anna', 'an'), [('An', true), ('na', false)]);
      expect(spans('Big Ann', 'ann'), [('Big ', false), ('Ann', true)]);
      expect(spans('Joanna', 'an'), [('Jo', false), ('an', true), ('na', false)]);
    });

    test('prefers a word start over an earlier occurrence', () {
      expect(highlightRanges('Banana Anna', 'an'), [(7, 9)]);
    });

    test('bolds each word of a match in another order', () {
      expect(spans('Bell, Anna', 'anna bell'), [('Bell', true), (', ', false), ('Anna', true)]);
    });

    test('no match, no bold', () {
      expect(spans('Zoe', 'an'), [('Zoe', false)]);
    });
  });
}
