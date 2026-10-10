import '../../core/config/haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';

/// Light, system or dark; shared by the settings and the theme picker
/// shown after the first login.
class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight), icon: const Icon(Icons.light_mode_outlined)),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l.themeSystem),
          icon: const Icon(Icons.brightness_auto_outlined),
        ),
        ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark), icon: const Icon(Icons.dark_mode_outlined)),
      ],
      selected: {ref.watch(themeModeProvider)},
      onSelectionChanged: (s) {
        Haptics.selection();
        ref.read(themeModeProvider.notifier).set(s.first);
      },
    );
  }
}

/// Round swatches of [accentColors]; the choice applies right away.
class AccentColorPicker extends ConsumerWidget {
  const AccentColorPicker({super.key, this.alignment = WrapAlignment.start});

  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final accent = ref.watch(accentColorProvider);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: alignment,
      children: [
        for (final MapEntry(key: name, value: color) in accentColors.entries)
          _AccentSwatch(
            name: accentColorName(l, name),
            color: color,
            selected: color.toARGB32() == accent.toARGB32(),
            onTap: () {
              Haptics.selection();
              ref.read(accentColorProvider.notifier).set(color);
            },
          ),
      ],
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({required this.name, required this.color, required this.selected, required this.onTap});

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Shown as it will look in the current light/dark mode.
    final shown = AppTheme.accentFor(color, Theme.of(context).brightness);
    return Tooltip(
      message: name,
      child: Semantics(
        label: context.l10n.accentColorLabel(name),
        selected: selected,
        button: true,
        child: InkResponse(
          onTap: onTap,
          radius: 26,
          child: Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: shown,
              // The Stash theme shows both of its colors.
              gradient: AppTheme.isStash(color)
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.5, 0.5],
                      colors: [shown, AppTheme.accentFor(stashBrown, Theme.of(context).brightness)],
                    )
                  : null,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3) : null,
            ),
            child: selected ? Icon(Icons.check, color: readableOn(shown)) : null,
          ),
        ),
      ),
    );
  }
}

/// Display name of an entry of [accentColors].
String accentColorName(AppLocalizations l, String name) => switch (name) {
  'Red' => l.colorRed,
  'Pink' => l.colorPink,
  'Purple' => l.colorPurple,
  'Indigo' => l.colorIndigo,
  'Blue' => l.colorBlue,
  'Teal' => l.colorTeal,
  'Green' => l.colorGreen,
  'Orange' => l.colorOrange,
  'Amber' => l.colorAmber,
  'Stash' => l.colorStash,
  _ => name,
};
