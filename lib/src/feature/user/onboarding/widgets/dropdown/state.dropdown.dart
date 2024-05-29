import 'package:flutter/material.dart';

import 'package:rtiapp/src/feature/user/onboarding/service/onboarding.service.dart';

class StateDropdownForm extends StatefulWidget {
  final Function(Map<String, dynamic>?) onStateChanged;

  const StateDropdownForm({super.key, required this.onStateChanged});

  @override
  State<StateDropdownForm> createState() => _StateDropdownFormState();
}

class _StateDropdownFormState extends State<StateDropdownForm> {
  Map<String, dynamic>? _selectedGender;

  var state = OnboardingServices();

  final List<Map<String, dynamic>> _listOfStates = [];

  @override
  void initState() {
    getState();
    super.initState();
  }

  getState() async {
    var states = await state.fetchState();
    var l = states["data"] as List;
    l.map(
      (e) {
        _listOfStates.add(e as Map<String, dynamic>);
      },
    ).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'State',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      value: _selectedGender,
      items: _listOfStates.map((Map<String, dynamic> value) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: value,
          child: Text(value["name"]),
        );
      }).toList(),
      onChanged: (Map<String, dynamic>? newValue) async {
        setState(() {
          _selectedGender = newValue;
        });
        widget.onStateChanged(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select state';
        }
        return null;
      },
    );
  }
}
