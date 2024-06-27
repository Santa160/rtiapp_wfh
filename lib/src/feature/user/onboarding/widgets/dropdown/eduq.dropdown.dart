import 'package:flutter/material.dart';

import 'package:rtiapp/src/feature/user/onboarding/service/onboarding.service.dart';

class EduQDropdownForm extends StatefulWidget {
  final Function(Map<String, dynamic>?) onEduQChanged;

  const EduQDropdownForm({
    super.key,
    required this.onEduQChanged,
  });

  @override
  State<EduQDropdownForm> createState() => _EduQDropdownFormState();
}

class _EduQDropdownFormState extends State<EduQDropdownForm> {
  Map<String, dynamic>? _selectedEduQ;
  String? _isLiterate = "Literate";

  var state = OnboardingServices();

  final List<Map<String, dynamic>> _listOfEduQ = [];

  var dto = {
    'education_status': '1', //1=Literate, 0= Illiterate
    'qualification_id': '3', //
  };

  _updatedEduQ() {
    widget.onEduQChanged(dto);
  }

  @override
  void initState() {
    getEduQ();
    super.initState();
  }

  getEduQ() async {
    var states = await state.fetchEduQ();
    var l = states["data"] as List;
    l.map(
      (e) {
        _listOfEduQ.add(e as Map<String, dynamic>);
      },
    ).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Radio(
                    value: "Literate",
                    groupValue: _isLiterate,
                    onChanged: (value) {
                      setState(() {
                        _isLiterate = value;
                        dto["education_status"] = value!;
                      });
                      _updatedEduQ();
                    }),
                const Text("Literate")
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Illiterate",
                    groupValue: _isLiterate,
                    onChanged: (value) {
                      setState(() {
                        _isLiterate = value;
                        dto["education_status"] = value!;
                      });
                      dto["qualification_id"] = '3';
                      _updatedEduQ();
                    }),
                const Text("Illiterate")
              ],
            ),
          ],
        ),
        if (_isLiterate == "Literate")
          DropdownButtonFormField<Map<String, dynamic>>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: _selectedEduQ == null ? 'Education Qualification' : '',
              labelStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
            ),
            value: _selectedEduQ,
            items: _listOfEduQ.map((Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Text(value["name"]),
              );
            }).toList(),
            onChanged: _isLiterate == "Literate"
                ? (Map<String, dynamic>? newValue) async {
                    setState(() {
                      _selectedEduQ = newValue;
                    });
                    dto["qualification_id"] = newValue!["id"].toString();
                    _updatedEduQ();
                  }
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select Education Qualification';
              }
              if (_isLiterate == 'Illiterate') {
                return null;
              }
              return null;
            },
          ),
      ],
    );
  }
}
