import 'package:flutter/material.dart';

class MaritalStatusDropdownForm extends StatefulWidget {
  final Function(String?) onStatusChanged;

  const MaritalStatusDropdownForm({super.key, required this.onStatusChanged});

  @override
  State<MaritalStatusDropdownForm> createState() =>
      _MaritalStatusDropdownFormState();
}

class _MaritalStatusDropdownFormState extends State<MaritalStatusDropdownForm> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Marital Status',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      value: _selectedStatus,
      items: <String>['Married', 'Unmarried', 'Divorced'].map((String value) {
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
          return 'Please select Marital Status';
        }
        return null;
      },
    );
  }
}
