import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
import 'package:flutter/material.dart';

class SelectionFieldsDemo extends StatefulWidget {
  const SelectionFieldsDemo({super.key});

  @override
  State<SelectionFieldsDemo> createState() => _SelectionFieldsDemoState();
}

class _SelectionFieldsDemoState extends State<SelectionFieldsDemo> {
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
      final termsOptions = results.getAsRaw<List<form.FieldOption>>('terms');
      debugPrint(
        'Terms accepted: ${termsOptions?.map((o) => o.label).join(', ') ?? 'none'}',
      );
      debugPrint('Newsletter: ${results.grab('newsletter').asBool()}');
      debugPrint('Framework: ${results.grab('framework').asString()}');
      debugPrint('Platform: ${results.grab('platform').asString()}');
      debugPrint('Pricing: ${results.grab('pricing').asString()}');
      debugPrint(
        'Technologies: ${results.grab('technologies').asStringList().join(', ')}',
      );

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
      // Checkbox Field
      ShadcnCheckboxField(
        id: 'terms',
        title: 'Terms and Conditions',
        description: 'Please review and accept the following:',
        options: [
          form.FieldOption(
            label: 'I agree to the terms and conditions',
            value: 'terms_accepted',
          ),
          form.FieldOption(
            label: 'I agree to the privacy policy',
            value: 'privacy_accepted',
          ),
          form.FieldOption(
            label: 'I want to receive marketing emails',
            value: 'marketing_accepted',
          ),
        ],
        multiselect: true,
        defaultValue: [], // Initialize with empty list
        validateLive: true,

        validators: [
          form.Validator(
            validator: (value) {
              if (value is! List) return false;
              // Must accept both terms and privacy policy
              return value.any((opt) => opt.value == 'terms_accepted') &&
                  value.any((opt) => opt.value == 'privacy_accepted');
            },
            reason: 'You must accept the terms and privacy policy',
          ),
        ],
      ),

      // Switch Field
      ShadcnSwitchField(
        id: 'newsletter',
        title: "Switch Field",
        options: [
          form.FieldOption(
            label: 'Newsletter Subscription',
            value: 'subscribed',
          ),
          form.FieldOption(label: 'Promotional Emails', value: 'promotional'),
          form.FieldOption(label: 'Product Updates', value: 'updates'),
        ],
        multiselect: true,
        defaultValue: [],
        labelOnLeft: false,
      ),

      // Select Field - single-select mode (default)
      ShadcnSelectField(
        id: 'framework',
        title: 'Select Framework (Single)',
        description: 'Choose your preferred framework (required)',
        options: [
          form.FieldOption(label: 'Flutter', value: 'flutter'),
          form.FieldOption(label: 'React', value: 'react'),
          form.FieldOption(label: 'Vue', value: 'vue'),
          form.FieldOption(label: 'Angular', value: 'angular'),
          form.FieldOption(label: 'Svelte', value: 'svelte'),
        ],
        multiselect: false, // Single-select mode (default)
        defaultValue: [], // Empty list means no selection
        validateLive: false, // Only validates on submit
        validators: [
          form.Validator(
            validator: (value) {
              // value is List<FieldOption>, check if not empty
              return value is List && value.isNotEmpty;
            },
            reason: 'Please select a framework',
          ),
        ],
      ),

      // Select Field - multi-select mode (using same field with multiselect: true)
      ShadcnSelectField(
        id: 'frameworks_multi',
        title: 'Select Frameworks (Multi)',
        description: 'Choose multiple frameworks',
        options: [
          form.FieldOption(label: 'Flutter', value: 'flutter'),
          form.FieldOption(label: 'React', value: 'react'),
          form.FieldOption(label: 'Vue', value: 'vue'),
          form.FieldOption(label: 'Angular', value: 'angular'),
          form.FieldOption(label: 'Svelte', value: 'svelte'),
        ],
        multiselect: true, // Multi-select mode
        defaultValue: [],
      ),

      // Radio Group Field
      ShadcnRadioGroupField(
        id: 'platform',
        title: 'Target Platform',
        description: 'Select your deployment platform',
        options: [
          form.FieldOption(label: 'iOS', value: 'ios'),
          form.FieldOption(label: 'Android', value: 'android'),
          form.FieldOption(label: 'Web', value: 'web'),
          form.FieldOption(label: 'Desktop', value: 'desktop'),
        ],
        defaultValue: [], // Empty list = no selection
      ),

      // Radio Card Field - submit-time validation
      ShadcnRadioCardField(
        id: 'pricing',
        title: 'Select Plan',
        description: 'Choose a pricing plan (required)',
        options: [
          form.FieldOption(
            label: 'Free',
            value: 'free',
            hintText: 'Basic features',
          ),
          form.FieldOption(
            label: 'Pro',
            value: 'pro',
            hintText: 'Advanced features',
          ),
          form.FieldOption(
            label: 'Enterprise',
            value: 'enterprise',
            hintText: 'All features + support',
          ),
        ],
        defaultValue: [], // Empty list = no selection
        validateLive: false, // Only validates on submit

        validators: [
          form.Validator(
            validator: (value) {
              // value is List<FieldOption>, check if not empty
              return value is List && value.length > 2;
            },
            reason: 'Please select at least two',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Selection Fields'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selection Field Demonstrations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This demo showcases selection fields using the new Field API: checkbox, switch, select, radio group, and multiselect.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Validation info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Validation Examples:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Terms Checkboxes: Must accept terms AND privacy (live validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Framework Select: Required selection (submit validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Radio Card: Must select an option (submit validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Technologies: Select 1-3 items (live validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
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
