import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/initial-setup/models/status.model.dart';

class ApplicationStatusDropdown extends StatefulWidget {
  const ApplicationStatusDropdown(
      {super.key, required this.initialId, required this.onChanged});
  final String initialId;
  final Function(StatusModel) onChanged;

  @override
  State<ApplicationStatusDropdown> createState() =>
      _ApplicationStatusDropdownState();
}

class _ApplicationStatusDropdownState extends State<ApplicationStatusDropdown> {
  List<StatusModel> loo = [];

  StatusModel? _selectedStatus;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() async {
    var list = await SharedPrefHelper.getStatus();
    if (list != null) {
      loo = list;
    }
    _selectedStatus = loo.firstWhere(
      (element) => element.name == widget.initialId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<StatusModel>(
      value: _selectedStatus,
      onChanged: (StatusModel? newValue) {
        setState(() {
          _selectedStatus = newValue!;
          widget.onChanged(newValue);
        });
      },
      items: loo.map<DropdownMenuItem<StatusModel>>((StatusModel item) {
        return DropdownMenuItem<StatusModel>(
          value: item,
          child: Text(item.name),
        );
      }).toList(),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
