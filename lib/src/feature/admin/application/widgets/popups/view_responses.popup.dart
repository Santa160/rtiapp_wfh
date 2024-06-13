import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_network/image_network.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/application/models/req-models/StringUnit8.model.dart';
import 'package:rtiapp/src/feature/admin/application/services/rti_staff.service.dart';
import 'package:rtiapp/src/feature/admin/application/widgets/image_picker.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dropdowns/query.status.dropdown.dart';

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
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("second"),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit_square,
                          color: Colors.grey,
                        ))
                  ],
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

// class EditResponsePopup extends StatefulWidget {
//   const EditResponsePopup({super.key, required this.onUpdate});
//   final Function(dynamic) onUpdate;

//   @override
//   State<EditResponsePopup> createState() => _EditResponsePopupState();
// }

// class _EditResponsePopupState extends State<EditResponsePopup> {
//   TextEditingController controller = TextEditingController();
//   QueryStatusModel? _selectedQueryStatus;
//   List<StringUint8ListModel> _files = [];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 500,
//       height: 500,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Response",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const Gap(20),
//             TextFormField(
//               controller: controller,
//               maxLines: 5,
//               decoration: const InputDecoration(
//                 hintText: "Enter your response here...",
//                 label: Text("Response"),
//               ),
//             ),
//             const Gap(20),
//             QueryStatusDropdown(
//                 onChanged: (status) async {
//                   _selectedQueryStatus = status;
//                   setState(() {});
//                 },
//                 initialId: queries[index]["query_status_id"]),
//             const Gap(20),
//             ImagePickerFormWidget(
//               onPicked: (files) {
//                 _files = files;

//                 setState(() {});
//               },
//             ),
//             const Gap(20)
//           ],
//         ),
//       ),
//     );
//   }
// }
