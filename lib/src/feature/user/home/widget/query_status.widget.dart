import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';

import 'package:rtiapp/src/initial-setup/models/query_status.dart';


import 'package:shimmer_animation/shimmer_animation.dart';

class QueryStatusWidget extends StatefulWidget {
  const QueryStatusWidget({super.key, required this.id});
  final int id;

  @override
  State<QueryStatusWidget> createState() => _QueryStatusWidgetState();
}

class _QueryStatusWidgetState extends State<QueryStatusWidget> {
  List<QueryStatusModel> _status = [];
  @override
  void initState() {
    fetchRTIStatus();
    super.initState();
  }

  fetchRTIStatus() async {
    var res = await SharedPrefHelper.getQueryStatus();
    if (res != null) {
      setState(() {
        _status = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _status.isEmpty
        ? Shimmer(child: Container())
        : Text(
            _status
                .where(
                  (element) => element.id == widget.id,
                )
                .first
                .name,
            style: TextStyle(color: getColor(widget.id)),
          );
  }

  getColor(int id) {
    if (id == 1) {
      return KCOLOR.danger;
    } else if (id == 2) {
      return KCOLOR.warning;
    } else if (id == 3) {
      return KCOLOR.success;
    } else {
      return KCOLOR.brand;
    }
  }
}
