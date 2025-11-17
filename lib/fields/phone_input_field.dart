import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/colorscheme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A custom field that displays a phone number input widget.
///
/// Supports international phone numbers with country selection and automatic
/// formatting based on the selected country.
///
/// ## Usage
///
/// ```dart
/// final phoneField = PhoneInputField(
///   id: 'phone',
///   title: 'Phone Number',
///   initialCountry: shadcn.Country.unitedStates,
/// );
/// ```
class PhoneInputField extends form.Field {
  /// The initial country to display in the country selector.
  final shadcn.Country? initialCountry;

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

  // PhoneInput-specific parameters
  final bool? enabled;
  final Widget? placeholder;
  final Widget? leading;
  final Widget? trailing;

  PhoneInputField({
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
    this.initialCountry,
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
    this.enabled,
    this.placeholder,
    this.leading,
    this.trailing,
  });

  @override
  PhoneInputField copyWith({
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
      FieldColorScheme,
      Widget,
    )? fieldLayout,
    Widget Function(
      BuildContext,
      form.Field,
      form.FormController,
      FieldColorScheme,
      Widget,
    )? fieldBackground,
    shadcn.Country? initialCountry,
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
    bool? enabled,
    Widget? placeholder,
    Widget? leading,
    Widget? trailing,
  }) {
    return PhoneInputField(
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
      initialCountry: initialCountry ?? this.initialCountry,
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
      enabled: enabled ?? this.enabled,
      placeholder: placeholder ?? this.placeholder,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
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
  List<form.FileModel>? Function(dynamic value)? get asFileListConverter =>
      null;
}

/// ShadCN phone input field for ChampionForms.
///
/// A specialized phone number input field using ShadCN's PhoneInput component.
/// Supports international phone numbers with country selection and automatic
/// formatting based on the selected country.
///
/// The field stores the phone number as a formatted string. Use the PhoneNumber
/// object from onChange callbacks to access country code and formatted values.
///
/// Example:
/// ```dart
/// form.TextField(
///   id: 'phone',
///   title: 'Phone Number',
///   fieldBuilder: (ctx) => ShadcnPhoneInputWidget(
///     context: ctx,
///     initialCountry: Country.unitedStates,
///   ),
/// )
/// ```
class ShadcnPhoneInputWidget extends form.StatefulFieldWidget {
  final shadcn.Country? initialCountry;

  const ShadcnPhoneInputWidget({
    required super.context,
    this.initialCountry,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    form.FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    // Note: PhoneInput has limited customization. The field-level parameters
    // are defined for API consistency but are not currently used by the component.
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

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
          child: shadcn.PhoneInput(
            key: ValueKey('phoneinput_${ctx.field.id}'),
            initialCountry: initialCountry ?? shadcn.Country.unitedStates,
            onChanged: (phoneNumber) {
              // Store the formatted phone number value
              final phoneValue = phoneNumber.value;
              ctx.setValue(phoneValue);
            },
            // Note: PhoneInput has limited customization parameters.
            // Most TextField parameters are not supported.
          ),
        ),
        if (ctx.field.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(ctx.field.description!, style: theme.hintTextStyle),
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
