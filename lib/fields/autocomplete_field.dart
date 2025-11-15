import 'package:flutter/material.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays an autocomplete text input widget.
///
/// Provides autocomplete suggestions as the user types.
///
/// ## Usage
///
/// ```dart
/// final searchField = ShadcnAutoCompleteField(
///   id: 'search',
///   title: 'Search',
///   suggestions: ['Apple', 'Banana', 'Cherry', 'Date', 'Fig'],
///   placeholder: 'Type to search...',
/// );
/// ```
class ShadcnAutoCompleteField extends form.Field {
  /// The list of suggestions to display.
  final List<String> suggestions;

  /// The placeholder text to display when the field is empty.
  final String? placeholder;

  @override
  final String? defaultValue;

  ShadcnAutoCompleteField({
    required super.id,
    super.title,
    super.description,
    super.disabled = false,
    super.hideField = false,
    super.requestFocus = false,
    super.validators,
    super.validateLive = false,
    super.onSubmit,
    super.onChange,
    super.theme,
    super.fieldLayout,
    super.fieldBackground,
    this.suggestions = const [],
    this.placeholder,
    this.defaultValue,
  });

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is String) return value;
        if (value == null) return '';
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is String) return [value];
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is String) return value.isNotEmpty;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Autocomplete text field using ShadCN Flutter's AutoComplete widget.
///
/// This field provides autocomplete suggestions as the user types.
/// Value Type: String
/// Converter: TextFieldConverters (built-in)
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'search',
///   title: 'Search',
///   fieldBuilder: (ctx) => ShadcnAutoCompleteWidget(
///     context: ctx,
///     suggestions: ['Apple', 'Banana', 'Cherry', 'Date', 'Fig'],
///   ),
/// )
/// ```
class ShadcnAutoCompleteWidget extends form.StatefulFieldWidget {
  final List<String> suggestions;
  final String? placeholder;

  const ShadcnAutoCompleteWidget({
    required super.context,
    this.suggestions = const [],
    this.placeholder,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    final value = ctx.getValue<String>() ?? '';

    // Filter suggestions based on current value
    final filteredSuggestions = value.isEmpty
        ? <String>[]
        : suggestions
            .where((s) => s.toLowerCase().contains(value.toLowerCase()))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (if present)
        if (ctx.field.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              ctx.field.title!,
              style: theme.titleStyle?.copyWith(
                color: hasError ? errorColors.titleColor : null,
              ),
            ),
          ),

        // AutoComplete with TextField
        Container(
          decoration: BoxDecoration(
            border: hasError
                ? Border.all(
                    color: errorColors.borderColor,
                    width: errorColors.borderSize.toDouble(),
                  )
                : null,
            borderRadius: hasError ? errorColors.borderRadius : null,
          ),
          child: shadcn.AutoComplete(
            suggestions: filteredSuggestions,
            child: shadcn.TextField(
              key: ValueKey('autocomplete_${ctx.field.id}'),
              controller: ctx.getTextController(),
              focusNode: ctx.getFocusNode(),
              placeholder: placeholder != null ? Text(placeholder!) : null,
              enabled: !ctx.field.disabled,
              features: const [
                shadcn.InputFeature.trailing(Icon(shadcn.LucideIcons.search)),
              ],
            ),
          ),
        ),

        // Description (if present)
        if (ctx.field.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(ctx.field.description!, style: theme.hintTextStyle),
          ),
        if (hasError)
          ...errors.map((error) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error.reason,
                  style: TextStyle(
                    color: errorColors.textColor,
                    fontSize: 12,
                  ),
                ),
              )),
      ],
    );
  }

  @override
  void onValueChanged(dynamic oldValue, dynamic newValue) {
    if (context.field.onChange != null) {
      final results = form.FormResults.getResults(controller: context.controller);
      context.field.onChange!(results);
    }
  }
}
