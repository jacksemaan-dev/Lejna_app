import 'package:flutter/material.dart';
import '../../models/unit.dart';
import '../../utils/bylaw_math.dart';

/// A form for admins to create a new charge. Supports both fixed charges
/// (same amount per unit) and bylaw-based charges (total divided by
/// shares). A preview table shows how much each unit would owe.
class CreateChargePage extends StatefulWidget {
  const CreateChargePage({super.key});
  @override
  State<CreateChargePage> createState() => _CreateChargePageState();
}

class _CreateChargePageState extends State<CreateChargePage> {
  final _formKey = GlobalKey<FormState>();
  String _mode = 'fixed';
  final _amountController = TextEditingController();
  final _totalController = TextEditingController();

  // Example units list; in the real app this would come from Firestore
  final List<Unit> _units = const [
    Unit(id: 'u1', label: 'Apt 1', sharePerMille: 125),
    Unit(id: 'u2', label: 'Apt 2', sharePerMille: 125),
    Unit(id: 'u3', label: 'Apt 3', sharePerMille: 125),
    Unit(id: 'u4', label: 'Apt 4', sharePerMille: 125),
    Unit(id: 'u5', label: 'Apt 5', sharePerMille: 125),
    Unit(id: 'u6', label: 'Apt 6', sharePerMille: 125),
    Unit(id: 'u7', label: 'Apt 7', sharePerMille: 125),
    Unit(id: 'u8', label: 'Apt 8', sharePerMille: 125),
  ];

  Map<String, double>? _preview;

  @override
  void dispose() {
    _amountController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    if (_mode == 'fixed') {
      final value = double.tryParse(_amountController.text);
      if (value == null) return;
      setState(() {
        _preview = {for (final u in _units) u.label: value};
      });
    } else {
      final total = double.tryParse(_totalController.text);
      if (total == null) return;
      final splits = calculateBylawSplits(total, _units);
      setState(() {
        _preview = {for (final u in _units) u.label: splits[u.id] ?? 0.0};
      });
    }
  }

  void _publish() {
    if (_preview == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter amount to see preview')));
      return;
    }
    // TODO: save charge and split amounts to Firestore
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Charge published')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Charge')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Fixed per unit'),
                      value: 'fixed',
                      groupValue: _mode,
                      onChanged: (value) {
                        if (value != null) setState(() => _mode = value);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Bylaw total'),
                      value: 'bylaw',
                      groupValue: _mode,
                      onChanged: (value) {
                        if (value != null) setState(() => _mode = value);
                      },
                    ),
                  ),
                ],
              ),
              if (_mode == 'fixed')
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount per unit'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePreview(),
                ),
              if (_mode == 'bylaw')
                TextFormField(
                  controller: _totalController,
                  decoration: const InputDecoration(labelText: 'Total amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePreview(),
                ),
              const SizedBox(height: 16),
              if (_preview != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preview'),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: [
                        const TableRow(children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Unit')),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Amount')),
                        ]),
                        ..._preview!.entries.map((e) => TableRow(children: [
                              Padding(padding: const EdgeInsets.all(8.0), child: Text(e.key)),
                              Padding(padding: const EdgeInsets.all(8.0), child: Text('\$${e.value.toStringAsFixed(2)}')),
                            ])).toList(),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _publish,
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}