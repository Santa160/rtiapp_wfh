import 'package:flutter/material.dart';

class GenderDropdownForm extends StatefulWidget {
  final Function(String?) onGenderChanged;

  const GenderDropdownForm({
    super.key,
    required this.onGenderChanged,
  });

  @override
  State<GenderDropdownForm> createState() => _GenderDropdownFormState();
}

class _GenderDropdownFormState extends State<GenderDropdownForm> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: _selectedGender == null ? 'Gender' : '',
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
      ),
      value: _selectedGender,
      items: <String>['Male', 'Female', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) async {
        setState(() {
          _selectedGender = newValue;
        });
        widget.onGenderChanged(newValue);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }
}
