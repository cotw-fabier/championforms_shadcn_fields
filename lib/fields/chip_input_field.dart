import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Field definition for chip input.
///
/// Stores multiple values as a List<FieldOption>, where each chip is represented
/// by a FieldOption with label and value properties.
///
/// ## Usage
///
/// ```dart
/// final tagsField = ChipInputField(
///   id: 'tags',
///   title: 'Tags',
///   description: 'Enter tags for this item',
///   suggestions: [
///     form.FieldOption(label: 'Hello World', value: 'hello'),
///     form.FieldOption(label: 'Lorem Ipsum', value: 'lorem'),
///   ],
///   placeholder: 'Add tags...',
///   defaultValue: [
///     form.FieldOption(label: 'Initial Tag', value: 'initial'),
///   ],
/// );
/// ```
class ChipInputField extends form.Field {
  /// Suggestions to display in the autocomplete dropdown.
  final List<form.FieldOption> suggestions;

  /// Placeholder text to display when no chips are present.
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

  // ChipInput-specific parameters
  final bool? useChips;
  final bool? autoInsertSuggestion;
  final ValueChanged<List<form.FieldOption>>? onChipsChanged;

  @override
  final List<form.FieldOption>? defaultValue;

  ChipInputField({
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
    this.useChips,
    this.autoInsertSuggestion,
    this.onChipsChanged,
    this.defaultValue,
  });

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults
  // Uses the ChipInputOptionConverters pattern for List<FieldOption>

  @override
  String Function(dynamic value) get asStringConverter => (value) {
        if (value is List<form.FieldOption>) {
          return value.map((opt) => opt.label).join(', ');
        }
        if (value == null) return '';
        throw TypeError();
      };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
        if (value is List<form.FieldOption>) {
          return value.map((opt) => opt.value).toList();
        }
        if (value == null) return [];
        throw TypeError();
      };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
        if (value is List<form.FieldOption>) return value.isNotEmpty;
        if (value == null) return false;
        throw TypeError();
      };

  @override
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Chip input field using ShadCN Flutter's ChipInput widget.
///
/// This field allows users to enter multiple tags/chips as FieldOption values.
/// Value Type: List<FieldOption>
/// Converter: ChipInputOptionConverters (custom)
///
/// Each chip is stored as a FieldOption with:
/// - value: the chip text (used for storage/comparison)
/// - label: display text (defaults to value if not provided)
/// - additionalData: optional metadata
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'tags',
///   title: 'Tags',
///   fieldBuilder: (ctx) => ShadcnChipInputWidget(
///     context: ctx,
///     suggestions: [
///       form.FieldOption(label: 'Hello World', value: 'hello'),
///       form.FieldOption(label: 'Lorem Ipsum', value: 'lorem'),
///     ],
///     placeholder: 'Add tags...',
///   ),
/// )
/// ```
class ShadcnChipInputWidget extends StatefulWidget {
  final form.FieldBuilderContext context;

  const ShadcnChipInputWidget({
    required this.context,
    super.key,
  });

  @override
  State<ShadcnChipInputWidget> createState() => _ShadcnChipInputWidgetState();
}

class _ShadcnChipInputWidgetState extends State<ShadcnChipInputWidget> {
  late shadcn.ChipEditingController<String> _chipController;
  List<form.FieldOption> _filteredSuggestions = [];
  dynamic _lastValue;

  // Get field-specific properties
  ChipInputField get _field => widget.context.field as ChipInputField;
  List<form.FieldOption> get _suggestions => _field.suggestions;
  String? get _placeholder => _field.placeholder;

  @override
  void initState() {
    super.initState();

    // Initialize chip controller with current value (convert FieldOptions to strings)
    final initialOptions = widget.context.getValue<List<form.FieldOption>>() ?? [];
    final initialChipStrings = initialOptions.map((opt) => opt.label).toList();

    _chipController = shadcn.ChipEditingController<String>(
      initialChips: initialChipStrings,
    );

    // Initialize last value
    _lastValue = initialOptions;

    // Listen to chip controller changes and update form value
    _chipController.addListener(_onChipsChanged);

    // Listen to form controller updates
    widget.context.controller.addListener(_onControllerUpdate);
  }

  void _onChipsChanged() {
    // Convert chip strings back to FieldOptions
    final chipOptions = _chipController.chips.map((chipLabel) {
      // Try to find matching option from suggestions by label
      final matchingSuggestion = _suggestions.firstWhere(
        (opt) => opt.label.toLowerCase() == chipLabel.toLowerCase(),
        orElse: () => form.FieldOption(
          value: chipLabel.toLowerCase().replaceAll(' ', '_'),
          label: chipLabel,
        ),
      );
      return matchingSuggestion;
    }).toList();

    // Update the form controller with the FieldOption list
    widget.context.setValue<List<form.FieldOption>>(chipOptions);

    // Call onChipsChanged callback if provided
    if (_field.onChipsChanged != null) {
      _field.onChipsChanged!(chipOptions);
    }

    // Update suggestions based on current text
    setState(() {
      final currentText = _chipController.textAtCursor;
      if (currentText.isNotEmpty) {
        _filteredSuggestions = _suggestions
            .where((opt) => opt.label.toLowerCase().startsWith(currentText.toLowerCase()))
            .toList();
      } else {
        _filteredSuggestions = [];
      }
    });
  }

  void _onControllerUpdate() {
    final newValue = widget.context.getValue<List<form.FieldOption>>();
    if (newValue != _lastValue) {
      _onValueChanged(_lastValue, newValue);
      _lastValue = newValue;

      // Update chip controller if value changed externally
      if (newValue != null) {
        final newChipStrings = newValue.map((opt) => opt.label).toList();
        if (!_listsEqual(_chipController.chips, newChipStrings)) {
          _chipController.chips = newChipStrings;
        }
      }

      setState(() {});
    }
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _onValueChanged(dynamic oldValue, dynamic newValue) {
    if (widget.context.field.onChange != null) {
      final results =
          form.FormResults.getResults(controller: widget.context.controller);
      widget.context.field.onChange!(results);
    }
  }

  @override
  void dispose() {
    _chipController.removeListener(_onChipsChanged);
    _chipController.dispose();
    widget.context.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    final ctx = widget.context;

    return Column(
      key: ValueKey('chipinput_col_${ctx.field.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shadcn.AutoComplete(
          suggestions: _filteredSuggestions.map((opt) => opt.label).toList(),
          child: shadcn.ChipInput<String>(
            key: ValueKey('chipinput_${ctx.field.id}'),
            controller: _chipController,
            placeholder: _placeholder != null
                ? Text(_placeholder!)
                : _field.hintText != null
                    ? Text(_field.hintText!)
                    : null,
            enabled: !ctx.field.disabled,
            onChipSubmitted: (value) {
              setState(() {
                _filteredSuggestions = [];
              });
              return value.trim();
            },
            chipBuilder: (context, chip) {
              return Text(chip);
            },
            keyboardType: _field.keyboardType,
            textInputAction: _field.textInputAction,
            maxLines: _field.maxLines,
            minLines: _field.minLines,
            inputFormatters: _field.inputFormatters,
            style: _field.style,
            readOnly: _field.readOnly ?? false,
            obscureText: _field.obscureText ?? false,
            autocorrect: _field.autocorrect ?? true,
            enableSuggestions: _field.enableSuggestions ?? true,
            maxLength: _field.maxLength,
            autofocus: _field.autofocus ?? false,
          ),
        ),
      ],
    );
  }
}
