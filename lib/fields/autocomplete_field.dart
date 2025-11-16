import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Common TextField parameters
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final List<shadcn.InputFeature>? features;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? readOnly;
  final bool? obscureText;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final int? maxLength;
  final bool? autofocus;
  final String? hintText;
  final shadcn.Border? border;
  final BorderRadiusGeometry? borderRadius;
  final bool? filled;

  // AutoComplete-specific parameters
  final BoxConstraints? popoverConstraints;
  final shadcn.PopoverConstraint? popoverWidthConstraint;
  final AlignmentDirectional? popoverAnchorAlignment;
  final AlignmentDirectional? popoverAlignment;
  final shadcn.AutoCompleteMode? mode;
  final shadcn.AutoCompleteCompleter? completer;

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
    this.keyboardType,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.features,
    this.style,
    this.textAlign,
    this.readOnly,
    this.obscureText,
    this.autocorrect,
    this.enableSuggestions,
    this.maxLength,
    this.autofocus,
    this.hintText,
    this.border,
    this.borderRadius,
    this.filled,
    this.popoverConstraints,
    this.popoverWidthConstraint,
    this.popoverAnchorAlignment,
    this.popoverAlignment,
    this.mode,
    this.completer,
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
  const ShadcnAutoCompleteWidget({
    required super.context,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as ShadcnAutoCompleteField;
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    final value = ctx.getValue<String>() ?? '';

    // Filter suggestions based on current value
    final filteredSuggestions = value.isEmpty
        ? <String>[]
        : field.suggestions
            .where((s) => s.toLowerCase().contains(value.toLowerCase()))
            .toList();

    // Build default features if not provided
    final effectiveFeatures = field.features ??
        const [shadcn.InputFeature.trailing(Icon(shadcn.LucideIcons.search))];

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
              placeholder: field.placeholder != null
                  ? Text(field.placeholder!)
                  : field.hintText != null
                      ? Text(field.hintText!)
                      : null,
              enabled: !ctx.field.disabled,
              features: effectiveFeatures,
              keyboardType: field.keyboardType,
              textInputAction: field.textInputAction,
              maxLines: field.maxLines,
              minLines: field.minLines,
              inputFormatters: field.inputFormatters,
              style: field.style,
              readOnly: field.readOnly ?? false,
              obscureText: field.obscureText ?? false,
              autocorrect: field.autocorrect ?? true,
              enableSuggestions: field.enableSuggestions ?? true,
              maxLength: field.maxLength,
              autofocus: field.autofocus ?? false,
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
