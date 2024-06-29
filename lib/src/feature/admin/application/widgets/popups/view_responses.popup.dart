import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';

import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';

import 'package:rtiapp/src/feature/admin/application/widgets/popups/edit_response.popup.dart';

import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewResponsePopup extends StatefulWidget {
  const ViewResponsePopup({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<ViewResponsePopup> createState() => _ViewResponsePopupState();
}

class _ViewResponsePopupState extends State<ViewResponsePopup> {
  Map<String, dynamic> _response = {};
  List<Map<String, dynamic>> doc = [];

  var msg = 'Loading...';

  @override
  void initState() {
    getResponses();
    super.initState();
  }

  getResponses() async {
    var service = ApplicationService();
    var res = await service.fetchResponseById(widget.data["id"]);

    if (res == 'No Response') {
      msg = res;
      setState(() {});
    }
    msg = res["message"] as String;

    _response = res["data"] as Map<String, dynamic>;
    var list = res['data']['documents'] as List;
    list.map(
      (e) {
        doc.add(e as Map<String, dynamic>);
      },
    ).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 800,
      child: _response.isEmpty
          ? Center(
              child: Text(msg),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.heading(
                      _response["responded_by_user_name"],
                      color: KCOLOR.brand,
                    ),
                    Visibility(
                      visible: SharedPrefHelper.isStaff()!,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            editResponseDialog(context);
                          },
                          icon: const Icon(
                            Icons.edit_square,
                            color: Colors.grey,
                          )),
                    )
                  ],
                ),
                AppText.subheading(_response["response"]),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: doc.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: TextButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                        onPressed: () {
                          launchUrl(Uri.parse(
                              "${EndPoint.baseUrl}/${e["document_url"]}"));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }

  Future<dynamic> editResponseDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(30),
          content: EditResponsePopup(
            doc: doc,
            response: _response,
            queryStatusId: widget.data['query_status_id'],
          ),
        );
      },
    );
  }
}
