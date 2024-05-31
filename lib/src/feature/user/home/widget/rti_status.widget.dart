import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';

class RTIStatusWidget extends StatefulWidget {
  const RTIStatusWidget({super.key, required this.id});
  final int id;

  @override
  State<RTIStatusWidget> createState() => _RTIStatusWidgetState();
}

class _RTIStatusWidgetState extends State<RTIStatusWidget> {
  List<RTIStatusModel> _status = [];
  @override
  void initState() {
    getStatus();
    super.initState();
  }

  getStatus() async {
    var status = await SharedPrefHelper.loadListFromSharedPreferences();
    if (status.isEmpty) {

      logger.e("empty");
      fetchRTIStatus();
    }else{

   
    setState(() {
      _status = status;
    });
    }
  }

  fetchRTIStatus() async {
    var res = await RTIService().fetchRTIStatus();
    var raw = res["data"] as List;

    var obj = raw
        .map(
          (e) => RTIStatusModel.fromJson(e),
        )
        .toList();
    await SharedPrefHelper.saveListToSharedPreferences(obj);
  }

  @override
  Widget build(BuildContext context) {
    return _status.isEmpty ? Container() : Text(_status.where((element) => element.id == widget.id,).first.name);
  }
}
