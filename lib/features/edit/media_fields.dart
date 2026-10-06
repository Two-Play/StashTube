import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/stash_image.dart';
import '../../l10n/l10n.dart';

/// A new image for an entity, as Stash's update inputs accept it: a data URI
/// with the image bytes, or a URL Stash downloads itself.
class ImageChoice {
  const ImageChoice.bytes(Uint8List this.bytes, this.mimeType) : url = null;
  const ImageChoice.url(String this.url)
      : bytes = null,
        mimeType = null;

  final Uint8List? bytes;
  final String? mimeType;
  final String? url;

  String get value => url ?? 'data:$mimeType;base64,${base64Encode(bytes!)}';
}

/// Picks a photo from the library, scaled down to a sensible upload size.
typedef PhotoPicker = Future<ImageChoice?> Function();

Future<ImageChoice?> pickPhotoFromLibrary() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2048, maxHeight: 2048, imageQuality: 90);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  return ImageChoice.bytes(bytes, file.mimeType ?? _mimeFromName(file.name));
}

String _mimeFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}

/// Shows the current image (or the newly chosen one) with "Choose photo" and
/// "From URL" (17.3).
class ImageEditField extends StatelessWidget {
  const ImageEditField({
    super.key,
    required this.label,
    required this.currentUrl,
    required this.choice,
    required this.onChanged,
    this.aspectRatio = 16 / 9,
    this.picker = pickPhotoFromLibrary,
  });

  final String label;
  final String? currentUrl;
  final ImageChoice? choice;
  final ValueChanged<ImageChoice?> onChanged;
  final double aspectRatio;
  final PhotoPicker picker;

  Future<void> _fromUrl(BuildContext context) async {
    final url = await showDialog<String>(context: context, builder: (_) => const _UrlDialog());
    if (url == null || url.isEmpty) return;
    if (!(Uri.tryParse(url)?.isAbsolute ?? false)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.invalidUrl)));
      }
      return;
    }
    onChanged(ImageChoice.url(url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final choice = this.choice;
    final Widget preview;
    if (choice?.bytes case final bytes?) {
      preview = Image.memory(bytes, fit: BoxFit.cover);
    } else if (choice?.url case final url?) {
      preview = Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.broken_image));
    } else {
      preview = StashImage(currentUrl, fallbackIcon: Icons.image_outlined);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: preview),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(context.l10n.choosePhoto),
                    onPressed: () async {
                      final picked = await picker();
                      if (picked != null) onChanged(picked);
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.link),
                    label: Text(context.l10n.fromUrl),
                    onPressed: () => _fromUrl(context),
                  ),
                  if (choice != null)
                    TextButton(onPressed: () => onChanged(null), child: Text(context.l10n.keepCurrentImage)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Asks for an image URL. Owns its text controller so it outlives the
/// dialog's closing animation.
class _UrlDialog extends StatefulWidget {
  const _UrlDialog();

  @override
  State<_UrlDialog> createState() => _UrlDialogState();
}

class _UrlDialogState extends State<_UrlDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(context.l10n.imageFromUrl),
        content: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(hintText: 'https://…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, _controller.text.trim()), child: Text(context.l10n.use)),
        ],
      );
}

/// Editable list of URLs (17.3).
class UrlListField extends StatefulWidget {
  const UrlListField({super.key, required this.urls, required this.onChanged});

  final List<String> urls;
  final ValueChanged<List<String>> onChanged;

  @override
  State<UrlListField> createState() => _UrlListFieldState();
}

class _UrlListFieldState extends State<UrlListField> {
  final _input = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _add() {
    final url = _input.text.trim();
    if (url.isEmpty) return;
    if (!(Uri.tryParse(url)?.isAbsolute ?? false)) {
      setState(() => _error = context.l10n.enterFullUrl);
      return;
    }
    setState(() => _error = null);
    _input.clear();
    if (!widget.urls.contains(url)) widget.onChanged([...widget.urls, url]);
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.urls, style: Theme.of(context).textTheme.labelLarge),
          for (final url in widget.urls)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.link),
              title: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                tooltip: context.l10n.removeUrl,
                icon: const Icon(Icons.close),
                onPressed: () => widget.onChanged(widget.urls.where((u) => u != url).toList()),
              ),
            ),
          TextField(
            controller: _input,
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _add(),
            decoration: InputDecoration(
              hintText: context.l10n.addUrl,
              errorText: _error,
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(tooltip: context.l10n.addUrl, icon: const Icon(Icons.add), onPressed: _add),
            ),
          ),
        ],
      );
}
