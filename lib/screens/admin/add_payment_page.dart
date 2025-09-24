import 'package:flutter/material.dart';

/// A form allowing an admin to record a payment from a resident. Payments
/// are tied to a specific unit and can be partial. This page is
/// illustrative only and does not persist data.
class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key});
  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedUnit = 'Apt 1';
  String _selectedMethod = 'Cash';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: call service to record payment and generate receipt
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Unit'),
                value: _selectedUnit,
                items: const [
                  DropdownMenuItem(value: 'Apt 1', child: Text('Apt 1')),
                  DropdownMenuItem(value: 'Apt 2', child: Text('Apt 2')),
                  DropdownMenuItem(value: 'Apt 3', child: Text('Apt 3')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedUnit = value);
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Method'),
                value: _selectedMethod,
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedMethod = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}