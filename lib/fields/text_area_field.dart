import 'package:flutter/material.dart';
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
/// final textAreaField = ShadcnTextAreaField(
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
class ShadcnTextAreaField extends form.Field {
  @override
  final String? defaultValue;

  ShadcnTextAreaField({
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
            placeholder: ctx.field.description != null
                ? Text(ctx.field.description!)
                : null,
            enabled: !ctx.field.disabled,
            expandableHeight: true,
            initialHeight: 150,
            onChanged: (value) {
              // debugPrint(value);
              ctx.setValue(value);
            },
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
