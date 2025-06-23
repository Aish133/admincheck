import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RetrForm extends StatefulWidget {
  const RetrForm({super.key});

  @override
  State<RetrForm> createState() => _RetrFormState();
}

class _RetrFormState extends State<RetrForm> {
  final _formKey = GlobalKey<FormState>();
  double totalCalculatedAmount = 0.0;
  final billingAmountController = TextEditingController();

  final List<String> grnStatusOptions = ['Drafted', 'Reviewed', 'Passed'];
  String? selectedGrnStatus;

  // Hardcoded controllers for RETR form
  final grnNoController = TextEditingController();
  final grnDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final inwardBnController = TextEditingController();
  final monthOfInvoiceController = TextEditingController(text: DateFormat('MMMM, yyyy').format(DateTime.now()));
  final supplierNameController = TextEditingController();
  final vendorChallanNoController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final invoiceDateController = TextEditingController();
  final poNoController = TextEditingController();
  final remarksController = TextEditingController();

  // Additional fields specific to returnable repair
  final returnDateController = TextEditingController();
  final repairStatusController = TextEditingController();
  final warrantyPeriodController = TextEditingController();

  final List<Map<String, dynamic>> itemEntries = [
    {
      'item': null,
      'unit': '',
      'poQty': '',
      'actualQty': '',
      'rate': '',
      'invoiceTotal': 0.0,
      'poTotal': '',
      'defectType': '',
      'repairNotes': '',
    },
  ];

  final List<String> availableItems = [
    'Resistor',
    'Capacitor',
    'IC Chip',
    'Connector',
    'Cable',
    'PCB Board',
    'Display Unit',
    'Power Supply',
  ];

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedGrnStatus,
        items: grnStatusOptions
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGrnStatus = value;
          });
        },
        decoration: const InputDecoration(
          labelText: 'GRN Status',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildItemEntry(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: itemEntries[index]['item'],
                    decoration: const InputDecoration(
                      labelText: 'Item',
                      border: OutlineInputBorder(),
                    ),
                    items: availableItems.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        itemEntries[index]['item'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['unit'],
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => itemEntries[index]['unit'] = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['poQty'],
                    decoration: const InputDecoration(
                      labelText: 'PO Qty',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        itemEntries[index]['poQty'] = val;
                        _updateItemTotal(index);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['actualQty'],
                    decoration: const InputDecoration(
                      labelText: 'Actual Qty',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        itemEntries[index]['actualQty'] = val;
                        _updateItemTotal(index);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['rate'],
                    decoration: const InputDecoration(
                      labelText: 'Rate/Unit',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        itemEntries[index]['rate'] = val;
                        _updateItemTotal(index);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['poTotal'],
                    decoration: const InputDecoration(
                      labelText: 'PO Total (Manual)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => itemEntries[index]['poTotal'] = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Additional fields for repair items
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['defectType'],
                    decoration: const InputDecoration(
                      labelText: 'Defect Type',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => itemEntries[index]['defectType'] = val,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: itemEntries[index]['repairNotes'],
                    decoration: const InputDecoration(
                      labelText: 'Repair Notes',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => itemEntries[index]['repairNotes'] = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Invoice Total: ₹${itemEntries[index]['invoiceTotal'].toStringAsFixed(2)}"),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Item',
                  onPressed: () {
                    setState(() {
                      itemEntries.removeAt(index);
                      _calculateTotalBilling();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateItemTotal(int index) {
    try {
      double rate = double.tryParse(itemEntries[index]['rate'] ?? '') ?? 0;
      double actualQty = double.tryParse(itemEntries[index]['actualQty'] ?? '') ?? 0;
      itemEntries[index]['invoiceTotal'] = rate * actualQty;
    } catch (_) {}
    _calculateTotalBilling();
  }

  void _calculateTotalBilling() {
    double total = 0;
    for (var item in itemEntries) {
      total += item['invoiceTotal'] ?? 0;
    }
    setState(() {
      totalCalculatedAmount = total;
    });
  }

  void _showPreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RETR Form Preview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('GRN Type: RETR (Returnable Repair)'),
                const SizedBox(height: 16),
                Text('GRN No: ${grnNoController.text}'),
                Text('GRN Date: ${grnDateController.text}'),
                Text('Inward B/N: ${inwardBnController.text}'),
                Text('Month of Invoice: ${monthOfInvoiceController.text}'),
                Text('Supplier Name: ${supplierNameController.text}'),
                Text('Vendor Challan No: ${vendorChallanNoController.text}'),
                Text('Invoice No: ${invoiceNoController.text}'),
                Text('Invoice Date: ${invoiceDateController.text}'),
                Text('PO No: ${poNoController.text}'),
                Text('Return Date: ${returnDateController.text}'),
                Text('Repair Status: ${repairStatusController.text}'),
                Text('Warranty Period: ${warrantyPeriodController.text}'),
                Text('Remarks: ${remarksController.text}'),
                if (selectedGrnStatus != null) 
                  Text('GRN Status: $selectedGrnStatus'),
                const SizedBox(height: 16),
                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...itemEntries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Item ${index + 1}: ${item['item'] ?? 'Not selected'}'),
                        Text('  Unit: ${item['unit']}'),
                        Text('  PO Qty: ${item['poQty']}'),
                        Text('  Actual Qty: ${item['actualQty']}'),
                        Text('  Rate: ₹${item['rate']}'),
                        Text('  Invoice Total: ₹${item['invoiceTotal'].toStringAsFixed(2)}'),
                        Text('  PO Total: ${item['poTotal']}'),
                        Text('  Defect Type: ${item['defectType']}'),
                        Text('  Repair Notes: ${item['repairNotes']}'),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Text('Manual Billing Amount: ₹${billingAmountController.text}'),
                Text('Calculated Billing Amount: ₹${totalCalculatedAmount.toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    grnNoController.dispose();
    grnDateController.dispose();
    inwardBnController.dispose();
    monthOfInvoiceController.dispose();
    supplierNameController.dispose();
    vendorChallanNoController.dispose();
    invoiceNoController.dispose();
    invoiceDateController.dispose();
    poNoController.dispose();
    returnDateController.dispose();
    repairStatusController.dispose();
    warrantyPeriodController.dispose();
    remarksController.dispose();
    billingAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'This form is for RETR (Returnable Repair) GRN entry.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField('GRN No', grnNoController),
                      _buildTextField('Inward B/N', inwardBnController),
                      _buildTextField('Supplier Name', supplierNameController),
                      _buildTextField('Vendor Challan No', vendorChallanNoController),
                      _buildTextField('Invoice No', invoiceNoController),
                      _buildTextField('PO No', poNoController),
                      _buildTextField('Return Date', returnDateController),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField('GRN Date', grnDateController),
                      _buildTextField('Month of Invoice', monthOfInvoiceController),
                      _buildTextField('Invoice Date', invoiceDateController),
                      _buildTextField('Repair Status', repairStatusController),
                      _buildTextField('Warranty Period', warrantyPeriodController),
                      _buildTextField('Remarks', remarksController),
                      _buildDropdownField(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Material Description (Items for Repair)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...itemEntries.asMap().entries.map((entry) {
              return _buildItemEntry(entry.key);
            }).toList(),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    itemEntries.add({
                      'item': null,
                      'unit': '0',
                      'poQty': '0',
                      'actualQty': '0',
                      'rate': '0',
                      'invoiceTotal': 0.0,
                      'poTotal': '0',
                      'defectType': '',
                      'repairNotes': '',
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: billingAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Manual Billing Amount Entry (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Calculated Billing Amount: ₹${totalCalculatedAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showPreview,
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('RETR Form Submitted')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}