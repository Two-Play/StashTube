/// Query completions for the search field (SEARCH-1): ranking and the
/// highlighted part. No widget or provider dependencies, so it is unit-tested
/// directly.
library;

/// Where a completion comes from.
enum CompletionKind { history, performer, tag, studio, scene }

/// A text the user can search for, with the entity it names (performers,
/// tags and studios) so the list can also open it.
class Completion {
  const Completion(this.text, this.kind, {this.id, this.imageUrl});

  final String text;
  final CompletionKind kind;
  final String? id;
  final String? imageUrl;

  bool get isEntity => id != null && kind != CompletionKind.history && kind != CompletionKind.scene;

  @override
  bool operator ==(Object other) =>
      other is Completion && other.text == text && other.kind == kind && other.id == id && other.imageUrl == imageUrl;

  @override
  int get hashCode => Object.hash(text, kind, id, imageUrl);

  @override
  String toString() => 'Completion($text, $kind)';
}

/// How well [text] completes [typed], case-insensitively: 0 starts with it,
/// 1 a word starts with it, 2 contains it, 3 contains all its words in
/// another order; null doesn't match (Stash also searches other fields, such
/// as aliases, which make no sense as a completion of the typed text).
int? matchRank(String text, String typed) {
  final t = text.toLowerCase();
  final q = typed.trim().toLowerCase();
  if (q.isEmpty) return null;
  if (t.startsWith(q)) return 0;
  if (_wordStart(t, q) != null) return 1;
  if (t.contains(q)) return 2;
  final words = _words(q);
  if (words.length > 1 && words.every(t.contains)) return 3;
  return null;
}

/// The parts of [text] that match [typed], as sorted, non-overlapping
/// `(start, end)` ranges: the occurrence that ranked it (a word start before
/// any other), or each word's first occurrence for a rank-3 match.
List<(int, int)> highlightRanges(String text, String typed) {
  final t = text.toLowerCase();
  final q = typed.trim().toLowerCase();
  // Lower-casing a few letters changes the length; don't misplace the bold.
  if (q.isEmpty || t.length != text.length) return const [];
  final whole =t.startsWith(q) ? 0 : (_wordStart(t, q) ?? t.indexOf(q));
  if (whole >= 0) return [(whole, whole + q.length)];

  final ranges = <(int, int)>[
    for (final w in _words(q))
      if (t.indexOf(w) case final i when i >= 0) (i, i + w.length),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  final merged = <(int, int)>[];
  for (final r in ranges) {
    if (merged.isNotEmpty && r.$1 <= merged.last.$2) {
      final last = merged.removeLast();
      merged.add((last.$1, r.$2 > last.$2 ? r.$2 : last.$2));
    } else {
      merged.add(r);
    }
  }
  return merged;
}

/// Matching entries of the search history, most relevant first (by rank,
/// then the most recent), at most [limit].
List<Completion> historyCompletions(List<String> history, String typed, {int limit = 3}) {
  final ranked = [
    for (final (i, h) in history.indexed)
      if (matchRank(h, typed) case final rank?) (rank, i, h),
  ]..sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));
  return [for (final r in ranked.take(limit)) Completion(r.$3, CompletionKind.history)];
}

/// Ranks the library [candidates] (in server order per kind) as completions
/// of [typed]: starts-with first, then word starts, then contains, each
/// ordered by kind and then server order. Texts are de-duplicated
/// case-insensitively (also against [exclude], the history rows above);
/// each kind gives at most [perKind] so one kind can't fill the list.
List<Completion> rankCompletions(
  String typed,
  Iterable<Completion> candidates, {
  int limit = 8,
  int perKind = 4,
  Iterable<String> exclude = const [],
}) {
  final ranked = [
    for (final (i, c) in candidates.indexed)
      if (matchRank(c.text, typed) case final rank?) (rank, i, c),
  ]..sort((a, b) {
      if (a.$1 != b.$1) return a.$1.compareTo(b.$1);
      if (a.$3.kind != b.$3.kind) return a.$3.kind.index.compareTo(b.$3.kind.index);
      return a.$2.compareTo(b.$2);
    });
  final seen = {for (final e in exclude) e.trim().toLowerCase()};
  final perKindCount = <CompletionKind, int>{};
  final result = <Completion>[];
  for (final (_, _, c) in ranked) {
    if (result.length >= limit) break;
    if ((perKindCount[c.kind] ?? 0) >= perKind) continue;
    if (!seen.add(c.text.trim().toLowerCase())) continue;
    perKindCount[c.kind] = (perKindCount[c.kind] ?? 0) + 1;
    result.add(c);
  }
  return result;
}

final _wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);

/// The first index where a word of [text] starts with [query] (both lower
/// case), or null.
int? _wordStart(String text, String query) {
  for (var i = text.indexOf(query); i >= 0; i = text.indexOf(query, i + 1)) {
    if (i == 0 || !_wordChar.hasMatch(text[i - 1])) return i;
  }
  return null;
}

List<String> _words(String query) => query.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
