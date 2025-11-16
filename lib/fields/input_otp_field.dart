import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:championforms/championforms.dart' as form;
import 'package:championforms/models/file_model.dart';
import 'package:championforms/models/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// An OTP (One-Time Password) input field using ShadCN Flutter's InputOTP component.
///
/// This field stores a String value representing the OTP code. It displays
/// individual character inputs for each digit and supports custom length
/// and separator configuration.
///
/// ## Usage
///
/// ```dart
/// final otpField = InputOTPField(
///   id: 'otp_code',
///   title: 'Verification Code',
///   description: 'Enter the code sent to your phone',
///   length: 6,
///   showSeparator: true,
///   defaultValue: '',
///   validators: [
///     form.Validator(
///       validator: (results) => results.grab('otp_code').asString().length == 6,
///       reason: 'Please enter all 6 digits',
///     ),
///   ],
/// );
/// ```
class InputOTPField extends form.Field {
  /// The number of OTP digits to display (default: 6)
  final int length;

  /// Whether to show a separator in the middle (default: true)
  final bool showSeparator;

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

  // InputOTP-specific parameter
  final List<shadcn.InputOTPChild>? children;

  @override
  final String? defaultValue;

  InputOTPField({
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
    this.length = 6,
    this.showSeparator = true,
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
    this.children,
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

/// Input OTP field using ShadCN Flutter's InputOTP component.
///
/// Displays an OTP (One-Time Password) input widget that allows users
/// to enter a verification code. Typically used for 2FA or verification flows.
///
/// Value type: `String`
/// Converter: `TextFieldConverters` (built-in)
///
/// Example:
/// ```dart
/// form.Field(
///   id: 'otp_code',
///   title: 'Verification Code',
///   description: 'Enter the 6-digit code sent to your phone',
///   fieldBuilder: (ctx) => ShadcnInputOTPWidget(
///     context: ctx,
///     length: 6,
///   ),
/// )
/// ```
class ShadcnInputOTPWidget extends form.StatefulFieldWidget {
  const ShadcnInputOTPWidget({
    required super.context,
    super.key,
  });

  @override
  Widget buildWithTheme(
    BuildContext buildContext,
    FormTheme theme,
    form.FieldBuilderContext ctx,
  ) {
    final field = ctx.field as InputOTPField;
    final errors = ctx.controller.findErrors(ctx.field.id);
    final hasError = errors.isNotEmpty;
    final errorColors = theme.errorColorScheme ?? ctx.colors;

    // Use provided children if available, otherwise build from length/separator
    final List<shadcn.InputOTPChild> effectiveChildren;
    if (field.children != null) {
      effectiveChildren = field.children!;
    } else {
      // Build the OTP children based on length
      effectiveChildren = <shadcn.InputOTPChild>[];
      final halfLength = field.length ~/ 2;

      for (int i = 0; i < field.length; i++) {
        // Add separator in the middle if enabled
        if (field.showSeparator && i == halfLength && field.length % 2 == 0) {
          effectiveChildren.add(shadcn.InputOTPChild.separator);
        }

        // Add character input
        effectiveChildren.add(
          shadcn.InputOTPChild.character(
            allowDigit: true,
          ),
        );
      }
    }

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

        // Input OTP Widget
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
          child: shadcn.InputOTP(
            key: ValueKey('inputotp_${ctx.field.id}'),
            onChanged: (otpValue) {
              final stringValue = otpValue.otpToString();
              ctx.setValue<String>(stringValue);
            },
            onSubmitted: (otpValue) {
              final stringValue = otpValue.otpToString();
              ctx.setValue<String>(stringValue);
            },
            children: effectiveChildren,
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
