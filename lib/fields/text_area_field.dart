import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A multi-line text area field using ShadCN Flutter's TextArea component.
///
/// This field stores a String value and supports expandable height, custom
/// initial height, and all standard ChampionForms features including validation
/// and onChange callbacks.
///
/// ## Usage
///
/// ```dart
/// final textAreaField = TextAreaField(
///   id: 'description',
///   title: 'Description',
///   description: 'Enter a detailed description',
///   defaultValue: '',
///   validators: [
///     form.Validator(
///       validator: (results) => results.grab('description').asString().length >= 10,
///       reason: 'Description must be at least 10 characters',
///     ),
///   ],
/// );
/// ```
class TextAreaField extends form.Field {
  @override
  final String? defaultValue;

  // TextField parameters (common to TextArea)
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

  // TextArea-specific parameters
  final double? minHeight;
  final double? maxHeight;
  final bool? expandableHeight;
  final bool? expandableWidth;
  final double? initialHeight;

  TextAreaField({
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
    this.defaultValue,
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
    this.minHeight,
    this.maxHeight,
    this.expandableHeight,
    this.expandableWidth,
    this.initialHeight,
  });

  @override
  TextAreaField copyWith({
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
    String? defaultValue,
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
    double? minHeight,
    double? maxHeight,
    bool? expandableHeight,
    bool? expandableWidth,
    double? initialHeight,
  }) {
    return TextAreaField(
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
      defaultValue: defaultValue ?? this.defaultValue,
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
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      expandableHeight: expandableHeight ?? this.expandableHeight,
      expandableWidth: expandableWidth ?? this.expandableWidth,
      initialHeight: initialHeight ?? this.initialHeight,
    );
  }

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
    if (value == null) return [''];
    throw TypeError();
  };

  @override
  bool Function(dynamic value) get asBoolConverter => (value) {
    if (value is String) return value.isNotEmpty;
    if (value == null) return false;
    throw TypeError();
  };

  @override
  List<FileModel>? Function(dynamic value)? get asFileListConverter => null;
}

/// ShadCN text area field for ChampionForms.
///
/// A multi-line text input field using ShadCN's TextArea component.
/// Supports expandable height, custom initial height, and all standard
/// ChampionForms features including validation and onChange callbacks.
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'description',
///   title: 'Description',
///   maxLines: null, // Allow multiline
///   fieldBuilder: (ctx) => ShadcnTextAreaWidget(context: ctx),
/// )
/// ```
class ShadcnTextAreaWidget extends form.StatefulFieldWidget {
  const ShadcnTextAreaWidget({required super.context, super.key});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as TextAreaField;
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    final textController = ctx.getTextController();
    final focusNode = ctx.getFocusNode();
    final value = ctx.getValue<String>() ?? '';

    // Ensure controller has current value
    if (textController.text != value) {
      textController.text = value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: shadcn.TextArea(
            key: ValueKey('textarea_${ctx.field.id}'),
            controller: textController,
            focusNode: focusNode,
            placeholder: field.hintText != null
                ? Text(field.hintText!)
                : (ctx.field.description != null
                      ? Text(ctx.field.description!)
                      : null),
            enabled: !ctx.field.disabled,
            onChanged: (value) {
              ctx.setValue(value);
            },
            keyboardType: field.keyboardType,
            textInputAction: field.textInputAction,
            maxLines: field.maxLines,
            minLines: field.minLines,
            inputFormatters: field.inputFormatters,
            features: field.features ?? [],
            style: field.style,
            textAlign: field.textAlign ?? TextAlign.start,
            readOnly: field.readOnly ?? false,
            obscureText: field.obscureText ?? false,
            autocorrect: field.autocorrect ?? true,
            enableSuggestions: field.enableSuggestions ?? true,
            maxLength: field.maxLength,
            autofocus: field.autofocus ?? false,
            border: field.border,
            borderRadius: field.borderRadius,
            filled: field.filled,
            minHeight: field.minHeight ?? 0,
            maxHeight: field.maxHeight ?? double.infinity,
            expandableHeight: field.expandableHeight ?? true,
            expandableWidth: field.expandableWidth ?? false,
            initialHeight: field.initialHeight ?? 150,
          ),
        ),
      ],
    );
  }

  @override
  void onValueChanged(dynamic oldValue, dynamic newValue) {
    if (context.field.onChange != null) {
      final results = form.FormResults.getResults(
        controller: context.controller,
      );
      context.field.onChange!(results);
    }
  }
}
