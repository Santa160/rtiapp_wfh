import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
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
                AppText.heading(
                  _response["responded_by_user_name"],
                  color: KCOLOR.brand,
                ),
                AppText.subheading(_response["response"]),

                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: doc.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      width: 80,
                      height: 80,
                      child: ImageNetwork(
                          onTap: () {
                            launchUrl(Uri.parse(
                                "${EndPoint.baseUrl}/${e["document_url"]}"));
                          },
                          height: 80,
                          width: 80,
                          image: "${EndPoint.baseUrl}/${e["document_url"]}"),
                    );
                  }).toList(),
                ),

                // Wrap(
                //   children: _documents
                //       .map(
                //         (e) => Container(
                //           height: 80,
                //           width: 80,
                //           color: KCOLOR.brand,
                //           // child: ImageNetwork(
                //           //   height: 80,
                //           //   width: 80,
                //           //   image: "${EndPoint.baseUrl}/${e["document_url"]}",
                //           // ),
                //         ),
                //       )
                //       .toList(),
                // ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: _response["documents"].length,
                //   itemBuilder: (context, index) {
                //     var d = _response["documents"][index];

                //     return ListTile(
                //       trailing: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: d.map(
                //           (e) {
                //             return Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: ImageNetwork(
                //                 onTap: () {
                //                   launchUrl(Uri.parse(
                //                       "${EndPoint.baseUrl}/${e["document_url"]}"));
                //                 },
                //                 height: 50,
                //                 width: 50,
                //                 image:
                //                     "${EndPoint.baseUrl}/${e["document_url"]}",
                //               ),
                //             );
                //           },
                //         ).toList(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
    );
  }
}
