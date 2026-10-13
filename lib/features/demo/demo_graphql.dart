import 'package:gql/ast.dart';
import 'package:gql/language.dart';

/// A field's value in the demo's object graph: computed when selected,
/// with the field's arguments.
typedef DemoField = Object? Function(Map<String, dynamic> args);

/// A small GraphQL executor for the demo server: runs the app's documents
/// against an object graph of maps (with `__typename`), whose values are
/// scalars, lists, nested maps or [DemoField]s. It doesn't validate against
/// the schema; a field the graph doesn't have resolves to null.
class DemoGraphql {
  DemoGraphql({required this.query, required this.mutation});

  /// The root objects.
  final Map<String, Object?> query;
  final Map<String, Object?> mutation;

  final _documents = <String, DocumentNode>{};

  /// The response body (`data` or `errors`) for a request.
  Map<String, dynamic> execute(String source, {Map<String, dynamic>? variables, String? operationName}) {
    try {
      final document = _documents[source] ??= parseString(source);
      final operations = document.definitions.whereType<OperationDefinitionNode>();
      final operation = operationName == null
          ? operations.single
          : operations.firstWhere((o) => o.name?.value == operationName);
      final run = _Run(
        {for (final f in document.definitions.whereType<FragmentDefinitionNode>()) f.name.value: f},
        {
          for (final v in operation.variableDefinitions)
            if (v.defaultValue?.value case final value?) v.variable.name.value: _Run.literal(value, const {}),
          ...?variables,
        },
      );
      final root = operation.type == OperationType.mutation ? mutation : query;
      return {'data': run.select(root, operation.selectionSet)};
    } catch (e) {
      return {
        'errors': [
          {'message': '$e'},
        ],
      };
    }
  }
}

class _Run {
  _Run(this.fragments, this.variables);

  final Map<String, FragmentDefinitionNode> fragments;
  final Map<String, dynamic> variables;

  Map<String, dynamic> select(Map<String, Object?> object, SelectionSetNode selectionSet) {
    final result = <String, dynamic>{};
    for (final selection in selectionSet.selections) {
      switch (selection) {
        case FieldNode():
          final name = selection.name.value;
          final args = {for (final a in selection.arguments) a.name.value: literal(a.value, variables)};
          var value = name == '__typename' ? object['__typename'] : object[name];
          if (value is DemoField) value = value(args);
          final key = selection.alias?.value ?? name;
          final subSelection = selection.selectionSet;
          result[key] = subSelection == null ? value : _complete(value, subSelection);
        case FragmentSpreadNode():
          final fragment = fragments[selection.name.value]!;
          if (_applies(fragment.typeCondition, object)) _merge(result, select(object, fragment.selectionSet));
        case InlineFragmentNode():
          if (_applies(selection.typeCondition, object)) _merge(result, select(object, selection.selectionSet));
      }
    }
    return result;
  }

  Object? _complete(Object? value, SelectionSetNode selectionSet) => switch (value) {
    null => null,
    Iterable() => [for (final item in value) _complete(item, selectionSet)],
    Map<String, Object?>() => select(value, selectionSet),
    _ => throw StateError('$value has no fields'),
  };

  static bool _applies(TypeConditionNode? condition, Map<String, Object?> object) =>
      condition == null || condition.on.name.value == object['__typename'];

  /// Merges a fragment's fields into [into], nested selections included.
  static void _merge(Map<String, dynamic> into, Map<String, dynamic> from) {
    for (final MapEntry(:key, :value) in from.entries) {
      final existing = into[key];
      if (existing is Map<String, dynamic> && value is Map<String, dynamic>) {
        _merge(existing, value);
      } else if (existing is List && value is List && existing.length == value.length) {
        for (var i = 0; i < value.length; i++) {
          if (existing[i] is Map<String, dynamic> && value[i] is Map<String, dynamic>) _merge(existing[i], value[i]);
        }
      } else {
        into[key] = value;
      }
    }
  }

  static dynamic literal(ValueNode node, Map<String, dynamic> variables) => switch (node) {
    VariableNode(:final name) => variables[name.value],
    IntValueNode(:final value) => int.parse(value),
    FloatValueNode(:final value) => double.parse(value),
    StringValueNode(:final value) => value,
    BooleanValueNode(:final value) => value,
    EnumValueNode(:final name) => name.value,
    ListValueNode(:final values) => [for (final v in values) literal(v, variables)],
    ObjectValueNode(:final fields) => {for (final f in fields) f.name.value: literal(f.value, variables)},
    _ => null,
  };
}
