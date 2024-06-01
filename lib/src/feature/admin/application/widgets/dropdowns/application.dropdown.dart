import 'package:flutter/material.dart';

class ApplicationStatusDropdown extends StatefulWidget {
  const ApplicationStatusDropdown({super.key, required this.initialId});
  final String initialId;

  @override
  State<ApplicationStatusDropdown> createState() =>
      _ApplicationStatusDropdownState();
}

class _ApplicationStatusDropdownState extends State<ApplicationStatusDropdown> {
  final List<Map<String, dynamic>> loo = [
    {"id": "1", "name": "Open"},
    {"id": "2", "name": "In Progress"}
  ];

  late String selectedStatusId;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() {
    setState(() {
      selectedStatusId = widget.initialId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: selectedStatusId,
      onChanged: (String? newValue) {
        setState(() {
          selectedStatusId = newValue!;
        });
      },
      items: loo.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(item['name']),
        );
      }).toList(),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
