import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/gallery.dart';
import '../../data/models/performer.dart';
import '../../data/models/scene.dart';
import '../../data/models/studio.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../player/player_providers.dart';
import '../player/scene_edits.dart';
import 'edit_common.dart';

/// Adds `key: value` to [changes] when it differs from [original].
void _diff(Map<String, dynamic> changes, String key, Object? original, Object? value) {
  if (original is List && value is List) {
    if (original.length == value.length && original.every(value.contains)) return;
  } else if (original == value) {
    return;
  }
  changes[key] = value;
}

String? _blankToNull(String text) => text.trim().isEmpty ? null : text.trim();

// ---------------------------------------------------------------- Scene

class SceneEditPage extends ConsumerStatefulWidget {
  const SceneEditPage({super.key, required this.scene});

  final Scene scene;

  @override
  ConsumerState<SceneEditPage> createState() => _SceneEditPageState();
}

class _SceneEditPageState extends ConsumerState<SceneEditPage> {
  late final _title = TextEditingController(text: widget.scene.title);
  late final _details = TextEditingController(text: widget.scene.details ?? '');
  late DateTime? _date = widget.scene.date;
  late Studio? _studio = widget.scene.studio;
  late List<Performer> _performers = widget.scene.performers;
  late bool _organized = widget.scene.organized;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<bool> _save() async {
    final s = widget.scene;
    final changes = <String, dynamic>{};
    _diff(changes, 'title', s.title, _title.text.trim());
    _diff(changes, 'details', s.details, _blankToNull(_details.text));
    _diff(changes, 'date', stashDate(s.date), stashDate(_date));
    _diff(changes, 'studio_id', s.studio?.id, _studio?.id);
    _diff(changes, 'performer_ids', [for (final p in s.performers) p.id], [for (final p in _performers) p.id]);
    _diff(changes, 'organized', s.organized, _organized);
    if (changes.isEmpty) return false;

    final updated = await ref.read(stashRepositoryProvider).updateScene(s.id, changes);
    ref.read(nowPlayingProvider.notifier).replaceScene(updated);
    ref.read(sceneEditsProvider.notifier).forget(updated.id);
    ref.invalidate(sceneListProvider);
    return true;
  }

  @override
  Widget build(BuildContext context) => EditScaffold(
        title: 'Edit scene',
        onSave: _save,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          ),
          TextField(
            controller: _details,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Details', border: OutlineInputBorder()),
          ),
          DateField(label: 'Date', value: _date, onChanged: (d) => setState(() => _date = d)),
          PickerField(
            label: 'Studio',
            text: _studio?.name,
            onTap: () async {
              final picked = await showStudioPicker(context);
              if (picked != null) setState(() => _studio = picked);
            },
            onClear: () => setState(() => _studio = null),
          ),
          PickerField(
            label: 'Performers',
            text: _performers.isEmpty ? null : _performers.map((p) => p.name).join(', '),
            onTap: () async {
              final picked = await showPerformerPicker(context, _performers);
              if (picked != null) setState(() => _performers = picked);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Organized'),
            subtitle: const Text('Metadata is complete'),
            value: _organized,
            onChanged: (v) => setState(() => _organized = v),
          ),
        ],
      );
}

// ---------------------------------------------------------------- Performer

const _genders = {
  'FEMALE': 'Female',
  'MALE': 'Male',
  'TRANSGENDER_FEMALE': 'Trans female',
  'TRANSGENDER_MALE': 'Trans male',
  'INTERSEX': 'Intersex',
  'NON_BINARY': 'Non-binary',
};

class PerformerEditPage extends ConsumerStatefulWidget {
  const PerformerEditPage({super.key, required this.performer});

  final Performer performer;

  @override
  ConsumerState<PerformerEditPage> createState() => _PerformerEditPageState();
}

class _PerformerEditPageState extends ConsumerState<PerformerEditPage> {
  late final _name = TextEditingController(text: widget.performer.name);
  late final _disambiguation = TextEditingController(text: widget.performer.disambiguation ?? '');
  late final _country = TextEditingController(text: widget.performer.country ?? '');
  late final _details = TextEditingController(text: widget.performer.details ?? '');
  late String? _gender = _genders.containsKey(widget.performer.gender) ? widget.performer.gender : null;
  late DateTime? _birthdate = widget.performer.birthdate;

  @override
  void dispose() {
    for (final c in [_name, _disambiguation, _country, _details]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<bool> _save() async {
    final p = widget.performer;
    if (_name.text.trim().isEmpty) throw StateError('A name is required');
    final changes = <String, dynamic>{};
    _diff(changes, 'name', p.name, _name.text.trim());
    _diff(changes, 'disambiguation', p.disambiguation, _blankToNull(_disambiguation.text));
    _diff(changes, 'country', p.country, _blankToNull(_country.text)?.toUpperCase());
    _diff(changes, 'details', p.details, _blankToNull(_details.text));
    _diff(changes, 'gender', _genders.containsKey(p.gender) ? p.gender : null, _gender);
    _diff(changes, 'birthdate', stashDate(p.birthdate), stashDate(_birthdate));
    if (changes.isEmpty) return false;

    await ref.read(stashRepositoryProvider).updatePerformer(p.id, changes);
    ref.invalidate(performerProvider(p.id));
    ref.invalidate(performerListProvider);
    return true;
  }

  @override
  Widget build(BuildContext context) => EditScaffold(
        title: 'Edit performer',
        onSave: _save,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
          TextField(
            controller: _disambiguation,
            decoration: const InputDecoration(labelText: 'Disambiguation', border: OutlineInputBorder()),
          ),
          DropdownButtonFormField<String?>(
            initialValue: _gender,
            decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('—')),
              for (final MapEntry(:key, :value) in _genders.entries) DropdownMenuItem(value: key, child: Text(value)),
            ],
            onChanged: (v) => setState(() => _gender = v),
          ),
          DateField(label: 'Birthdate', value: _birthdate, onChanged: (d) => setState(() => _birthdate = d)),
          TextField(
            controller: _country,
            maxLength: 2,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Country code',
              hintText: 'e.g. DE',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _details,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Details', border: OutlineInputBorder()),
          ),
        ],
      );
}

// ---------------------------------------------------------------- Studio

class StudioEditPage extends ConsumerStatefulWidget {
  const StudioEditPage({super.key, required this.studio});

  final Studio studio;

  @override
  ConsumerState<StudioEditPage> createState() => _StudioEditPageState();
}

class _StudioEditPageState extends ConsumerState<StudioEditPage> {
  late final _name = TextEditingController(text: widget.studio.name);
  late final _details = TextEditingController(text: widget.studio.details ?? '');
  late Studio? _parent = widget.studio.parent;

  @override
  void dispose() {
    _name.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<bool> _save() async {
    final s = widget.studio;
    if (_name.text.trim().isEmpty) throw StateError('A name is required');
    final changes = <String, dynamic>{};
    _diff(changes, 'name', s.name, _name.text.trim());
    _diff(changes, 'details', s.details, _blankToNull(_details.text));
    _diff(changes, 'parent_id', s.parent?.id, _parent?.id);
    if (changes.isEmpty) return false;

    await ref.read(stashRepositoryProvider).updateStudio(s.id, changes);
    ref.invalidate(studioProvider(s.id));
    ref.invalidate(studioListProvider);
    return true;
  }

  @override
  Widget build(BuildContext context) => EditScaffold(
        title: 'Edit studio',
        onSave: _save,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
          PickerField(
            label: 'Parent studio',
            text: _parent?.name,
            onTap: () async {
              final picked = await showStudioPicker(context);
              if (picked == null) return;
              if (!context.mounted) return;
              if (picked.id == widget.studio.id) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('A studio can\'t be its own parent')));
                return;
              }
              setState(() => _parent = picked);
            },
            onClear: () => setState(() => _parent = null),
          ),
          TextField(
            controller: _details,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Details', border: OutlineInputBorder()),
          ),
        ],
      );
}

// ---------------------------------------------------------------- Tag

class TagEditPage extends ConsumerStatefulWidget {
  const TagEditPage({super.key, required this.tag});

  final Tag tag;

  @override
  ConsumerState<TagEditPage> createState() => _TagEditPageState();
}

class _TagEditPageState extends ConsumerState<TagEditPage> {
  late final _name = TextEditingController(text: widget.tag.name);
  late final _description = TextEditingController(text: widget.tag.description ?? '');

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<bool> _save() async {
    final t = widget.tag;
    if (_name.text.trim().isEmpty) throw StateError('A name is required');
    final changes = <String, dynamic>{};
    _diff(changes, 'name', t.name, _name.text.trim());
    _diff(changes, 'description', t.description, _blankToNull(_description.text));
    if (changes.isEmpty) return false;

    await ref.read(stashRepositoryProvider).updateTag(t.id, changes);
    ref.invalidate(tagProvider(t.id));
    ref.invalidate(tagListProvider);
    return true;
  }

  @override
  Widget build(BuildContext context) => EditScaffold(
        title: 'Edit tag',
        onSave: _save,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name', prefixText: '#', border: OutlineInputBorder()),
          ),
          TextField(
            controller: _description,
            minLines: 2,
            maxLines: 6,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
          ),
        ],
      );
}

// ---------------------------------------------------------------- Gallery

class GalleryEditPage extends ConsumerStatefulWidget {
  const GalleryEditPage({super.key, required this.gallery});

  final Gallery gallery;

  @override
  ConsumerState<GalleryEditPage> createState() => _GalleryEditPageState();
}

class _GalleryEditPageState extends ConsumerState<GalleryEditPage> {
  late final _title = TextEditingController(text: widget.gallery.title);
  late final _details = TextEditingController(text: widget.gallery.details ?? '');
  late DateTime? _date = widget.gallery.date;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<bool> _save() async {
    final g = widget.gallery;
    final changes = <String, dynamic>{};
    _diff(changes, 'title', g.title, _title.text.trim());
    _diff(changes, 'details', g.details, _blankToNull(_details.text));
    _diff(changes, 'date', stashDate(g.date), stashDate(_date));
    if (changes.isEmpty) return false;

    await ref.read(stashRepositoryProvider).updateGallery(g.id, changes);
    ref.invalidate(galleryProvider(g.id));
    ref.invalidate(galleryListProvider);
    return true;
  }

  @override
  Widget build(BuildContext context) => EditScaffold(
        title: 'Edit gallery',
        onSave: _save,
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
          DateField(label: 'Date', value: _date, onChanged: (d) => setState(() => _date = d)),
          TextField(
            controller: _details,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Details', border: OutlineInputBorder()),
          ),
        ],
      );
}
