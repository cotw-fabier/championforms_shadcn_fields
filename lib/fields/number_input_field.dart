import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// Field definition for numeric input with spinner controls.
///
/// This field provides a text field with increment/decrement buttons for
/// numeric values.
///
/// Value Type: num (int or double)
/// Converter: NumericFieldConverters (built-in)
///
/// Example:
/// ```dart
/// NumberInputField(
///   id: 'quantity',
///   title: 'Quantity',
///   placeholder: 'Enter quantity',
///   step: 1,
///   min: 0,
///   max: 100,
///   defaultValue: 0,
/// )
/// ```
class NumberInputField extends form.Field {
  /// Placeholder text for the input field.
  final String? placeholder;

  /// Step value for increment/decrement operations.
  final num? step;

  /// Minimum allowed value.
  final num? min;

  /// Maximum allowed value.
  final num? max;

  /// Number of decimal places (0 for integers).
  final int decimals;

  /// Width of the input field.
  final double? width;

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

  @override
  final num? defaultValue;

  NumberInputField({
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
    this.placeholder,
    this.step,
    this.min,
    this.max,
    this.decimals = 0,
    this.width = 200,
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
    this.defaultValue,
  });

  @override
  NumberInputField copyWith({
    String? id,
    Widget? icon,
    String? title,
    String? description,
    bool? disabled,
    bool? hideField,
    bool? requestFocus,
    List<form.Validator>? validators,
    bool? validateLive,
    Function(form.FormResults)? onSubmit,
    Function(form.FormResults)? onChange,
    form.FormTheme? theme,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldLayout,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      form.FieldColorScheme,
      Widget,
    )? fieldBackground,
    String? placeholder,
    num? step,
    num? min,
    num? max,
    int? decimals,
    double? width,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int? maxLines,
    int? minLines,
    List<TextInputFormatter>? inputFormatters,
    List<shadcn.InputFeature>? features,
    TextStyle? style,
    TextAlign? textAlign,
    bool? readOnly,
    bool? obscureText,
    bool? autocorrect,
    bool? enableSuggestions,
    int? maxLength,
    bool? autofocus,
    String? hintText,
    shadcn.Border? border,
    BorderRadiusGeometry? borderRadius,
    bool? filled,
    num? defaultValue,
  }) {
    return NumberInputField(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      disabled: disabled ?? this.disabled,
      hideField: hideField ?? this.hideField,
      requestFocus: requestFocus ?? this.requestFocus,
      validators: validators ?? this.validators,
      validateLive: validateLive ?? this.validateLive,
      onSubmit: onSubmit ?? this.onSubmit,
      onChange: onChange ?? this.onChange,
      theme: theme ?? this.theme,
      fieldLayout: fieldLayout ?? this.fieldLayout,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      placeholder: placeholder ?? this.placeholder,
      step: step ?? this.step,
      min: min ?? this.min,
      max: max ?? this.max,
      decimals: decimals ?? this.decimals,
      width: width ?? this.width,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      features: features ?? this.features,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      readOnly: readOnly ?? this.readOnly,
      obscureText: obscureText ?? this.obscureText,
      autocorrect: autocorrect ?? this.autocorrect,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      maxLength: maxLength ?? this.maxLength,
      autofocus: autofocus ?? this.autofocus,
      hintText: hintText ?? this.hintText,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      filled: filled ?? this.filled,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  // --- Converter Implementations ---
  // These converters handle type conversion for FormResults

  @override
  String Function(dynamic value) get asStringConverter => (value) {
    if (value is num) return value.toString();
    if (value == null) return '';
    throw TypeError();
  };

  @override
  List<String> Function(dynamic value) get asStringListConverter => (value) {
    if (value is num) return [value.toString()];
    if (value == null) return [];
    throw TypeError();
  };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
    if (value is num) return value != 0;
    if (value == null) return false;
    throw TypeError();
  };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// Numeric input field with spinner controls using ShadCN Flutter's TextField
/// with InputFeature.spinner.
///
/// This field provides a text field with increment/decrement buttons for
/// numeric values.
/// Value Type: num (int or double)
/// Converter: NumericFieldConverters (built-in)
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'quantity',
///   title: 'Quantity',
///   fieldBuilder: (ctx) => ShadcnNumberInputWidget(
///     context: ctx,
///     placeholder: 'Enter quantity',
///     step: 1,
///     min: 0,
///     max: 100,
///   ),
/// )
/// ```
class ShadcnNumberInputWidget extends StatefulWidget {
  final form.FieldBuilderContext context;

  const ShadcnNumberInputWidget({
    required this.context,
    super.key,
  });

  @override
  State<ShadcnNumberInputWidget> createState() =>
      _ShadcnNumberInputWidgetState();
}

class _ShadcnNumberInputWidgetState extends State<ShadcnNumberInputWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  dynamic _lastValue;

  // Get field-specific properties
  NumberInputField get _field => widget.context.field as NumberInputField;

  @override
  void initState() {
    super.initState();
    _textController = widget.context.getTextController();
    _focusNode = widget.context.getFocusNode();

    // Initialize with current value
    final currentValue = widget.context.getValue<num>();
    if (currentValue != null) {
      _textController.text = _formatNumber(currentValue);
    }

    // Initialize last value
    _lastValue = currentValue;

    // Listen to form controller updates
    widget.context.controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    final newValue = widget.context.getValue<num>();
    if (newValue != _lastValue) {
      _onValueChanged(_lastValue, newValue);
      _lastValue = newValue;

      // Update text field if value changed externally
      if (newValue is num) {
        final formattedValue = _formatNumber(newValue);
        if (_textController.text != formattedValue) {
          _textController.text = formattedValue;
        }
      } else if (newValue == null) {
        _textController.text = '';
      }

      setState(() {});
    }
  }

  void _onValueChanged(dynamic oldValue, dynamic newValue) {
    if (widget.context.field.onChange != null) {
      final results = form.FormResults.getResults(
        controller: widget.context.controller,
      );
      widget.context.field.onChange!(results);
    }
  }

  String _formatNumber(num value) {
    if (_field.decimals > 0) {
      return value.toStringAsFixed(_field.decimals);
    }
    return value.toString();
  }

  num? _parseNumber(String text) {
    if (text.isEmpty) return null;

    if (_field.decimals > 0) {
      return double.tryParse(text);
    }
    return int.tryParse(text) ?? double.tryParse(text);
  }

  void _handleTextChanged(String text) {
    final value = _parseNumber(text);
    if (value != null) {
      // Apply min/max constraints
      num constrainedValue = value;
      if (_field.min != null && constrainedValue < _field.min!) {
        constrainedValue = _field.min!;
      }
      if (_field.max != null && constrainedValue > _field.max!) {
        constrainedValue = _field.max!;
      }

      widget.context.setValue<num>(constrainedValue);
    } else if (text.isEmpty) {
      widget.context.setValue<num?>(null);
    }
  }

  @override
  void dispose() {
    widget.context.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errors = widget.context.controller.findErrors(
      widget.context.field.id,
    );
    final hasError = errors.isNotEmpty;
    final theme = widget.context.theme;
    final errorColors = theme.errorColorScheme ?? widget.context.colors;
    final ctx = widget.context;

    // Build features list - use field.features if provided, otherwise default to spinner
    final effectiveFeatures = _field.features ?? const [shadcn.InputFeature.spinner()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Input with Spinner
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
          child: SizedBox(
            width: _field.width,
            child: shadcn.TextField(
              key: ValueKey('numberinput_${ctx.field.id}'),
              controller: _textController,
              focusNode: _focusNode,
              placeholder: _field.placeholder != null
                  ? Text(_field.placeholder!)
                  : _field.hintText != null
                      ? Text(_field.hintText!)
                      : null,
              enabled: !ctx.field.disabled,
              onChanged: _handleTextChanged,
              features: effectiveFeatures,
              submitFormatters: [shadcn.TextInputFormatters.mathExpression()],
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
        ),
      ],
    );
  }
}
