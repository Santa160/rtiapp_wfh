import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';

class ViewResponsePopup extends StatefulWidget {
  const ViewResponsePopup({super.key, this.data});
  final data;

  @override
  State<ViewResponsePopup> createState() => _ViewResponsePopupState();
}

class _ViewResponsePopupState extends State<ViewResponsePopup> {
  String? _responseId;
  List<Map<String, dynamic>> response = [];

  @override
  void initState() {
    getResponses();
    super.initState();
  }

  getResponses() async {
    _responseId = widget.data["id"];

    var service = ApplicationService();
    var res = await service.fetchResponseById(widget.data["id"]);
    var list = res["data"] as List;
    list.map(
      (e) {
        response.add(e as Map<String, dynamic>);
      },
    ).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 800,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: response.length,
        itemBuilder: (context, index) {
       
          var d = response[index];
          var doc = d["documents"] as List;
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: doc.map(
                (e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageNetwork(
                      height: 50,
                      width: 50,
                      image: "${EndPoint.baseUrl}/${e["document_url"]}",
                    ),
                  );
                },
              ).toList(),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d["response"].toString()),
                AppText.smallText(
                  "Responded by : ${d["responded_by"].toString()}",
                  color: KCOLOR.brand,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
