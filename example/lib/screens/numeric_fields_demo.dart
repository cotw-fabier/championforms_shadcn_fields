import 'package:championforms/championforms.dart' as form;
import 'package:championforms/championforms_themes.dart';
import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
import 'package:flutter/material.dart';

class NumericFieldsDemo extends StatefulWidget {
  const NumericFieldsDemo({super.key});

  @override
  State<NumericFieldsDemo> createState() => _NumericFieldsDemoState();
}

class _NumericFieldsDemoState extends State<NumericFieldsDemo> {
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
      debugPrint('Tags: ${results.grab('tags').asStringList().join(', ')}');
      debugPrint('Quantity: ${results.grab('quantity').asString()}');
      debugPrint('Volume: ${results.grab('volume').asString()}');
      debugPrint('Rating: ${results.grab('rating').asString()}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted! Check console for values.')),
      );
    } else {
      debugPrint('Form has errors:');
      for (final error in results.formErrors) {
        debugPrint('  ${error.fieldId}: ${error.reason}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix form errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = softBlueColorTheme(context);

    final fields = [
      // Chip/Tag Input Field
      ShadcnChipInputField(
        id: 'tags',
        title: 'Tags',
        description: 'Add tags by typing and pressing Enter',
        suggestions: [
          form.FieldOption(label: 'Flutter', value: 'flutter'),
          form.FieldOption(label: 'Dart', value: 'dart'),
          form.FieldOption(label: 'Mobile', value: 'mobile'),
          form.FieldOption(label: 'UI/UX', value: 'uiux'),
          form.FieldOption(label: 'Development', value: 'dev'),
          form.FieldOption(label: 'Design', value: 'design'),
        ],
        placeholder: 'Add tags...',
        defaultValue: [],
        validateLive: true,
        validators: [
          form.Validator(
            validator: (value) {
              if (value is! List) return false;
              return value.isNotEmpty && value.length <= 5;
            },
            reason: 'Please add 1-5 tags',
          ),
        ],
      ),

      // Number Input Field
      ShadcnNumberInputField(
        id: 'quantity',
        title: 'Quantity',
        description: 'Enter a quantity between 1 and 100',
        min: 1,
        max: 100,
        defaultValue: 1,
        step: 1,
        validateLive: true,
        validators: [
          form.Validator(
            validator: (value) {
              if (value is! num) return false;
              return value >= 1 && value <= 100;
            },
            reason: 'Quantity must be between 1 and 100',
          ),
        ],
      ),

      // Slider Field - submit-time validation
      ShadcnSliderField(
        id: 'volume',
        title: 'Volume',
        description: 'Adjust the volume level (min 30)',
        min: 0.0,
        max: 100.0,
        divisions: 100,
        initialValue: 50.0,
        showLabel: true,
        validateLive: false, // Only validates on submit
        validators: [
          form.Validator(
            validator: (value) {
              if (value == null) return false;
              // SliderValue has a value property (for single) or start/end (for range)
              final double sliderVal = (value as dynamic).value ?? 0.0;
              return sliderVal >= 0.3; // 30% of 0-1 range = 0.3
            },
            reason: 'Volume must be at least 30',
          ),
        ],
      ),

      // Star Rating Field
      ShadcnStarRatingField(
        id: 'rating',
        title: 'Rate Your Experience',
        description: 'Click to rate',
        defaultValue: null,
        validateLive: true,
        validators: [
          form.Validator(
            validator: (value) => value != null,
            reason: 'Please provide a rating',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Numeric & Input Fields'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Numeric & Input Field Demonstrations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This demo showcases numeric and special input fields using the new Field API: chip input, number input, slider, and star rating.',
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
                  Text('• Tags: Must add 1-5 tags (live validation)', style: TextStyle(fontSize: 13)),
                  Text('• Quantity: Must be between 1-100 (live validation)', style: TextStyle(fontSize: 13)),
                  Text('• Volume: Must be at least 30 (submit validation)', style: TextStyle(fontSize: 13)),
                  Text('• Rating: Rating required (live validation)', style: TextStyle(fontSize: 13)),
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

            const SizedBox(height: 16),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Field Value Types',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• ChipInput: List<FieldOption>'),
                  Text('• NumberInput: num (int or double)'),
                  Text('• Slider: SliderValue (converts to double)'),
                  Text('• StarRating: FieldOption with rating in additionalData'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
