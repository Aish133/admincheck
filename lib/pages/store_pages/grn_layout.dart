import 'package:flutter/material.dart';
import 'grn/gst_form.dart';
import 'grn/est_form.dart';
import 'grn/reta_form.dart';
import 'grn/retr_form.dart';
import 'grn/foc_form.dart';

class GrnPage extends StatefulWidget {
  const GrnPage({super.key});

  @override
  State<GrnPage> createState() => _GrnPageState();
}

class _GrnPageState extends State<GrnPage> {
  final List<String> grnTypes = [
    'GST (Not Returnable)',
    'EST (Non-GST, Not Returnable)',
    'RETR (Returnable Repair)',
    'RETA (Returnable Advance)',
    'FOC',
  ];

  String? selectedType;

  Widget? getSelectedForm() {
    switch (selectedType) {
      case 'GST (Not Returnable)':
        return const GstForm();
      case 'EST (Non-GST, Not Returnable)':
        return const EstForm();
      case 'RETR (Returnable Repair)':
        return const RetrForm();
      case 'RETA (Returnable Advance)':
        return const RetaForm();
      case 'FOC':
        return const FocForm();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedType == null) ...[
                  const Text(
                    'Select GRN Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: grnTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    hint: const Text('Choose GRN type'),
                  ),
                ] else ...[
                  getSelectedForm()!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}