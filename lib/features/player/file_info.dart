import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene_details.dart';
import '../../l10n/l10n.dart';

/// Technical details of a scene's files (path, size, codecs, ...), folded
/// into one line until tapped.
class FileInfoCard extends StatefulWidget {
  const FileInfoCard({super.key, required this.files});

  final List<SceneFile> files;

  @override
  State<FileInfoCard> createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final first = widget.files.first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l.fileInfoFiles(widget.files.length), style: theme.textTheme.titleSmall)),
                    Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
                if (!_expanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 26),
                    child: Text(
                      fileSummary(l, first),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  for (final (i, file) in widget.files.indexed) ...[
                    if (i > 0) const Divider(height: 24),
                    _FileDetails(file: file),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `1440p · h264 · 1.2 GB`: the most telling facts in one line.
String fileSummary(AppLocalizations l, SceneFile file) => [
      ?resolutionLabel(file.height),
      ?file.videoCodec,
      if (file.size != null) formatBytes(file.size!),
      if (file.bitRate != null) _bitRate(l, file.bitRate!),
    ].join(' · ');

String _bitRate(AppLocalizations l, int bitsPerSecond) =>
    l.megabitsPerSecond((bitsPerSecond / 1000000).toStringAsFixed(1));

class _FileDetails extends StatelessWidget {
  const _FileDetails({required this.file});

  final SceneFile file;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = <(String, String)>[
      (l.fileName, file.name),
      (l.filePath, file.path),
      if (file.size != null) (l.fileSize, formatBytes(file.size!)),
      if (file.format != null) (l.fileFormat, file.format!),
      if (file.width != null && file.height != null) (l.fileResolution, '${file.width} × ${file.height}'),
      if (file.duration != null) (l.fileDuration, formatDuration(file.duration!)),
      if (file.videoCodec != null) (l.fileVideoCodec, file.videoCodec!),
      if (file.audioCodec != null) (l.fileAudioCodec, file.audioCodec!),
      if (file.frameRate != null) (l.fileFrameRate, l.framesPerSecond(_trimZeros(file.frameRate!))),
      if (file.bitRate != null) (l.fileBitRate, _bitRate(l, file.bitRate!)),
      if (file.modified != null) (l.fileModified, formatDate(file.modified!.toLocal())),
    ];
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 96, child: Text(label, style: muted)),
                  Expanded(child: SelectableText(value, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: Text(l.copyPath),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(ClipboardData(text: file.path));
                messenger.showSnackBar(SnackBar(content: Text(l.pathCopied)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// `25`, `29.97`: frame rates without trailing zeros.
String _trimZeros(double value) =>
    value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
