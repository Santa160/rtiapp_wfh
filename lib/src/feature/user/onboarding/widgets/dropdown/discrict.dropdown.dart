import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/feature/user/onboarding/logic/cubit/dependent_drop_down_cubit.dart';

class DistrictDropdownForm extends StatefulWidget {
  final Function(Map<String, dynamic>?) onStateChanged;

  const DistrictDropdownForm({super.key, required this.onStateChanged});

  @override
  State<DistrictDropdownForm> createState() => _DistrictDropdownFormState();
}

class _DistrictDropdownFormState extends State<DistrictDropdownForm> {
  Map<String, dynamic>? _selectedGender;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<DependentDropDownCubit>().state;
    var d = state.data;
    return DropdownButtonFormField<Map<String, dynamic>>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'District',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      value: _selectedGender,
      items: d.map((Map<String, dynamic> value) {
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
          return 'Please select District';
        }
        return null;
      },
    );
  }
}
