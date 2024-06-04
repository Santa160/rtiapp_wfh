import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';

class QueryStatusDropdown extends StatefulWidget {
  const QueryStatusDropdown(
      {super.key, required this.initialId, required this.onChanged});
  final String initialId;
  final Function(QueryStatusModel) onChanged;

  @override
  State<QueryStatusDropdown> createState() => _QueryStatusDropdownState();
}

class _QueryStatusDropdownState extends State<QueryStatusDropdown> {
  List<QueryStatusModel> loo = [];

  QueryStatusModel? _selectedStatus;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() async {
    var list = await SharedPrefHelper.getQueryStatus();
    if (list != null) {
      loo = list;
    }
    _selectedStatus = loo.firstWhere(
      (element) => element.id.toString() == widget.initialId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<QueryStatusModel>(
      value: _selectedStatus,
      onChanged: (QueryStatusModel? newValue) {
        setState(() {
          _selectedStatus = newValue!;
          widget.onChanged(newValue);
        });
      },
      items:
          loo.map<DropdownMenuItem<QueryStatusModel>>((QueryStatusModel item) {
        return DropdownMenuItem<QueryStatusModel>(
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
