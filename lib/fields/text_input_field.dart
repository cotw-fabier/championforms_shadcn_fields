import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A text input field using ShadCN Flutter's TextField component.
///
/// This field stores a String value and supports all standard ChampionForms
/// features including validation, onChange callbacks, and theme integration.
///
/// ## Usage
///
/// ```dart
/// final textField = ShadcnTextInputField(
///   id: 'name',
///   title: 'Full Name',
///   description: 'Enter your full name',
///   defaultValue: '',
///   validators: [
///     form.Validator(
///       validator: (results) => results.grab('name').asString().isNotEmpty,
///       reason: 'Name is required',
///     ),
///   ],
/// );
/// ```
class ShadcnTextInputField extends form.Field {
  @override
  final String? defaultValue;

  // TextField parameters
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

  ShadcnTextInputField({
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

/// ShadCN text input field for ChampionForms.
///
/// A basic single-line text input field using ShadCN's TextField component.
/// Supports all standard ChampionForms features including validation,
/// onChange callbacks, and theme integration.
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'name',
///   title: 'Full Name',
///   fieldBuilder: (ctx) => ShadcnTextInputWidget(context: ctx),
/// )
/// ```
class ShadcnTextInputWidget extends form.StatefulFieldWidget {
  const ShadcnTextInputWidget({required super.context, super.key});

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as ShadcnTextInputField;
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
          child: shadcn.TextField(
            key: ValueKey('textfield_${ctx.field.id}'),
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
