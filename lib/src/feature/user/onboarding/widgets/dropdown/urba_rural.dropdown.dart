import 'package:flutter/material.dart';

class UrbanOrRuralDropdownForm extends StatefulWidget {
  final Function(String?) onStatusChanged;

  const UrbanOrRuralDropdownForm({super.key, required this.onStatusChanged});

  @override
  State<UrbanOrRuralDropdownForm> createState() =>
      _UrbanOrRuralDropdownFormState();
}

class _UrbanOrRuralDropdownFormState extends State<UrbanOrRuralDropdownForm> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Area Type',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      value: _selectedStatus,
      items: <String>['Urban', 'Rural'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) async {
        setState(() {
          _selectedStatus = newValue;
        });
        widget.onStatusChanged(newValue);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select area type';
        }
        return null;
      },
    );
  }
}
