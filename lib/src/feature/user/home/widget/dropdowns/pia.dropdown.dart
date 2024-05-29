import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/upload/upload_file.dart';

class PiaDropdownForm extends StatefulWidget {
  const PiaDropdownForm(
      {super.key, required this.questions, required this.file});
  final Function(List<String>?) questions;
  final Function(FilePickerModel?) file;

  @override
  State<PiaDropdownForm> createState() => _PiaDropdownFormState();
}

class _PiaDropdownFormState extends State<PiaDropdownForm> {
  Map<String, dynamic>? _selectedPia;
  final List<Map<String, dynamic>> _listOfPia = [];

  @override
  void initState() {
    getPia();
    super.initState();
  }

  getPia() async {
    _listOfPia.add({'id': '1', "name": "mspcl"});
    _listOfPia.add({'id': '2', "name": "asgas"});
  }

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constraints) {
      double containerWidth;
      if (mw > 800) {
        containerWidth = constraints.maxWidth / 3;
      } else if (mw > 600) {
        containerWidth = constraints.maxWidth / 2;
      } else {
        containerWidth = constraints.maxWidth / 1;
      }
      return Wrap(
        runSpacing: 4,
        children: [
          SizedBox(
            width: containerWidth,
            child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                child: DropdownButtonFormField<Map<String, dynamic>>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Pia',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPia,
                  items: _listOfPia.map((Map<String, dynamic> value) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: value,
                      child: Text(value["name"]),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? newValue) async {
                    setState(() {
                      _selectedPia = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select state';
                    }
                    return null;
                  },
                )),
          ),
          SizedBox(
              width: containerWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                child: UploadFileWidget(
                  onFilePicked: (value) {},
                ),
              ))
        ],
      );
    });
  }
}
