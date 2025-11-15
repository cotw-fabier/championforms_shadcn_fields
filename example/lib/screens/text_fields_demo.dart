import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:championforms_shadcn_fields/fields/autocomplete_field.dart';
import 'package:championforms_shadcn_fields/fields/phone_input_field.dart';
import 'package:championforms_shadcn_fields/fields/text_area_field.dart';
import 'package:championforms_shadcn_fields/fields/text_input_field.dart';
import 'package:flutter/material.dart';

class TextFieldsDemo extends StatefulWidget {
  const TextFieldsDemo({super.key});

  @override
  State<TextFieldsDemo> createState() => _TextFieldsDemoState();
}

class _TextFieldsDemoState extends State<TextFieldsDemo> {
  late form.FormController controller;

  @override
  void initState() {
    super.initState();
    controller = form.FormController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submitForm() {
    final results = form.FormResults.getResults(controller: controller);

    if (!results.errorState) {
      debugPrint('=== Form Submitted Successfully ===');
      debugPrint('Email: ${results.grab('email').asString()}');
      debugPrint('Bio: ${results.grab('bio').asString()}');
      debugPrint('Credit Card: ${results.grab('credit_card').asString()}');
      debugPrint('Phone: ${results.grab('phone').asString()}');
      debugPrint('Search: ${results.grab('search').asString()}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted! Check console for values.'),
        ),
      );
    } else {
      debugPrint('Form has errors:');
      for (final error in results.formErrors) {
        debugPrint('  ${error.fieldId}: ${error.reason}');
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fix form errors')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = softBlueColorTheme(context);

    final fields = [
      // Text Input Field
      ShadcnTextInputField(
        id: 'email',

        title: 'Email Address',
        // hintText: 'Enter your email',
        description: 'Standard text input field using ShadCN',
        // maxLines: 1,
        validateLive: true,
        validators: [
          form.Validator(
            validator: (results) => form.Validators.stringIsNotEmpty(results),
            reason: 'Email is required',
          ),
          form.Validator(
            validator: (results) => form.Validators.isEmail(results),
            reason: 'Please enter a valid email address',
          ),
        ],
      ),

      // Text Area Field (using TextField with maxLines)
      ShadcnTextAreaField(
        id: 'bio',
        title: 'Biography',
        // hintText: 'Tell us about yourself...',
        description: 'Multi-line text area using ShadCN',
        // maxLines: 4,
        validateLive: true,
        validators: [
          form.Validator(
            validator: (value) {
              // final value = results.grab('bio').asString();
              return value.length >= 10;
            },
            reason: 'Biography must be at least 10 characters',
          ),
        ],
      ),

      // Phone Input using ShadCN PhoneInput
      ShadcnPhoneInputField(
        id: 'phone',
        title: 'Phone Number',
        description: 'Phone number input with country selector',
        validateLive: true,
        validators: [
          form.Validator(
            validator: (value) {
              return value.length >= 10;
            },
            reason: 'Phone number must be at least 10 digits',
          ),
        ],
      ),

      // Search field using ShadCN AutoComplete
      ShadcnAutoCompleteField(
        id: 'search',
        title: 'Search Topics',
        placeholder: 'Start typing to search...',
        description: 'Autocomplete search field',
        suggestions: [
          'Flutter Development',
          'Dart Programming',
          'Mobile App Design',
          'State Management',
          'UI/UX Best Practices',
          'Performance Optimization',
          'Testing Strategies',
          'Deployment Pipelines',
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Text Input Fields'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Text Input Demonstrations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This demo showcases 5 text input field types: basic text input, text area, formatted input, phone input, and autocomplete.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            form.Form(
              controller: controller,
              theme: theme,
              spacing: 16,
              fieldPadding: const EdgeInsets.symmetric(vertical: 8),
              fields: fields,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Form'),
            ),
          ],
        ),
      ),
    );
  }
}
