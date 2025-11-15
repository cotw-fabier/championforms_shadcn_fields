import 'package:championforms_shadcn_fields/championforms_shadcn_fields.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'screens/text_fields_demo.dart';
import 'screens/selection_fields_demo.dart';
import 'screens/numeric_fields_demo.dart';
import 'screens/special_fields_demo.dart';

void main() {
  // Register all ShadCN Flutter fields with ChampionForms
  ShadcnFieldRegistry.registerAll();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.ShadcnApp(
      title: 'ShadCN Fields Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ShadCN Flutter Fields',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'ChampionForms Integration Examples',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              _DemoCard(
                title: 'Text Input Fields',
                description: 'TextField demonstrations with ShadCN components',
                icon: Icons.text_fields,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextFieldsDemo()),
                ),
              ),

              const SizedBox(height: 16),

              _DemoCard(
                title: 'Selection Fields',
                description: 'Checkbox, OptionSelect, and MultiSelect demos',
                icon: Icons.checklist,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectionFieldsDemo()),
                ),
              ),

              const SizedBox(height: 16),

              _DemoCard(
                title: 'Numeric & Input Fields',
                description: 'ChipInput and numeric field demonstrations',
                icon: Icons.numbers,
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NumericFieldsDemo()),
                ),
              ),

              const SizedBox(height: 16),

              _DemoCard(
                title: 'ShadCN Fields Registry',
                description: 'View all 21 registered ShadCN field types',
                icon: Icons.list,
                color: Colors.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpecialFieldsDemo()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
