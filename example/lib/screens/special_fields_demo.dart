import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
import 'package:flutter/material.dart';

class SpecialFieldsDemo extends StatefulWidget {
  const SpecialFieldsDemo({super.key});

  @override
  State<SpecialFieldsDemo> createState() => _SpecialFieldsDemoState();
}

class _SpecialFieldsDemoState extends State<SpecialFieldsDemo> {
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
      debugPrint('Event Date: ${results.grab('event_date').asString()}');
      debugPrint('Event Time: ${results.grab('event_time').asString()}');
      debugPrint('Theme Color: ${results.grab('theme_color').asString()}');
      debugPrint('Comments: ${results.grab('comments').asString()}');

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
      // Date Picker Field - submit-time validation (future date)
      // TODO: This field is bugged in the upstream ShadCN_Flutter Library
      // will need to wait for fixes before fully integrating
      DatePickerField(
        id: 'event_date',
        title: 'Event Date',
        description: 'Select a future event date',
        defaultValue: null,
        isRangeSelector: true,
        validateLive: false, // Only validates on submit
        validators: [
          form.Validator(
            validator: (value) {
              // value is FieldOption, extract DateTime from additionalData
              if (value is! form.FieldOption) return false;
              final date = ShadcnDatePickerWidget.extractDateTime(value);
              if (date == null) return false;
              // Check if date is in the future (ignoring time)
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final selectedDate = DateTime(date.year, date.month, date.day);
              return selectedDate.isAfter(today);
            },
            reason: 'Event date must be in the future',
          ),
        ],
      ),

      // Time Picker Field - submit-time validation
      // TODO: This field is bugged in the upstream ShadCN_Flutter Library
      // will need to wait for fixes before fully integrating
      TimePickerField(
        id: 'event_time',
        title: 'Event Time',
        description: 'Select the event time (required)',
        validateLive: false, // Only validates on submit
        validators: [
          form.Validator(
            validator: (value) => value != null,
            reason: 'Please select an event time',
          ),
        ],
      ),

      // Color Picker Field - submit-time validation
      ColorPickerField(
        id: 'theme_color',
        title: 'Theme Color',
        description: 'Choose your theme color (required)',
        validateLive: false, // Only validates on submit
        validators: [
          form.Validator(
            validator: (value) => value != null,
            reason: 'Please select a theme color',
          ),
        ],
      ),

      // Text Area for Comments - live validation
      TextAreaField(
        id: 'comments',
        title: 'Additional Comments',
        description: 'Share your thoughts (min 20 characters)',
        defaultValue: '',
        validateLive: true, // Shows errors as user types
        validators: [
          form.Validator(
            validator: (value) {
              if (value is! String) return false;
              return value.length >= 20;
            },
            reason: 'Comments must be at least 20 characters',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Special Fields'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Special Fields Demonstrations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This demo showcases date/time and color fields using the new Field API.',
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
                    '• Event Date: Must be in the future (submit validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Event Time: Required selection (submit validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Theme Color: Required selection (submit validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Comments: Minimum 20 characters (live validation)',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info box showing registered fields
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Registered ShadCN Fields',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Text Input Fields:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text('• shadcn_text_input, shadcn_text_area'),
                  Text('• shadcn_formatted_input, shadcn_phone_input'),
                  Text('• shadcn_autocomplete, shadcn_input_otp'),
                  SizedBox(height: 8),
                  Text(
                    'Selection Fields:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text('• shadcn_checkbox, shadcn_switch, shadcn_toggle'),
                  Text('• shadcn_radio_group, shadcn_radio_card'),
                  Text(
                    '• shadcn_select, shadcn_multiselect, shadcn_item_picker',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Numeric & Special Fields:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text('• shadcn_chip_input, shadcn_number_input'),
                  Text('• shadcn_slider, shadcn_star_rating'),
                  Text('• shadcn_date_picker, shadcn_time_picker'),
                  Text('• shadcn_color_picker'),
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
