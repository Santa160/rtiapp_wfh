import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/serial_number.dart';

import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/admin/application/widgets/popups/view_responses.popup.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/widget/query_status.widget.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';
import 'package:rtiapp/src/service/helper/endpoints.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

var _service = RTIService();

class RTIViewPage extends StatefulWidget {
  const RTIViewPage({super.key, required this.rtiId, required this.onBackTab});
  final String rtiId;
  final Function() onBackTab;

  @override
  State<RTIViewPage> createState() => _RTIViewPageState();
}

class _RTIViewPageState extends State<RTIViewPage> {
  Map<String, dynamic> data = {
    "status": " ",
  };
  // List<QueryStatusModel>? _queryStatus;

  Map<String, dynamic> citizenDetails = {};
  String applicationNo = '';
  Map<String, dynamic> bplDetails = {};
  List<Map<String, dynamic>> tableData = [];
  List queries = [];

  TextEditingController controller = TextEditingController();

  //rti logs
  List<Map<String, dynamic>> logsData = [];

  Map<String, dynamic> pagination = {};

  Map<String, dynamic> paymentOption = {};

  int initialPage = 1;
  int initialLimit = 5;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getRTIDetials();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var order = {
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature
    };

    var res = await _service.confirmResponsePayment(order);
    if (res['success']) {
      EasyLoading.showSuccess(res['message']);
      getRTIDetials();
    }
  }

  String unsuccessfulMsg = '';

  void _handlePaymentError(PaymentFailureResponse response) {
    unsuccessfulMsg = response.message!;
    EasyLoading.dismiss();
    setState(() {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.dismiss();
  }

  getRTIDetials() async {
    var res =
        await _service.fetchRTIDetails(widget.rtiId, initialPage, initialLimit);
    // var queryStatus = await SharedPrefHelper.getQueryStatus();

    setState(() {
      // _queryStatus = queryStatus;
      data = res["data"];

      citizenDetails = res["data"]["citizen_details"];
      applicationNo = res["data"]["rti_no"];
      queries = res["data"]["queries"];
      tableData.clear();
      var list = res["data"]["rti_status_log"] as List;
      pagination = res["data"]["pagination"];
      for (var element in list) {
        tableData.add(element as Map<String, dynamic>);
      }
      if (citizenDetails["bpl"] == "1") {
        bplDetails = res["data"]["bpl_details"];
      }
    });
  }

  _loader({double? height}) {
    return Shimmer(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
            color: KCOLOR.shade1,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: height ?? 110,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageHeader(context),
        const Gap(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText.heading(
              "Citizen Profile",
              color: KCOLOR.brand,
            ),
            const Gap(10),
            citizenDetails.isEmpty
                ? _loader(height: 110)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: userProfile()),
                      Expanded(child: userAddress()),
                    ],
                  ),
            const Gap(20),
            const AppText.heading(
              "Education",
              color: KCOLOR.brand,
            ),
            const Gap(10),
            citizenDetails.isEmpty ? _loader(height: 40) : _education(),
            if (citizenDetails["bpl"] == "1") ...[
              const Gap(20),
              const AppText.heading(
                "BPL",
                color: KCOLOR.brand,
              ),
              const Gap(10),
              citizenDetails.isEmpty
                  ? _loader(height: 110)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: _bpl()),
                        Expanded(
                            child: Stack(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    color: Colors.grey,
                                    width: 80,
                                    child: Visibility(
                                      visible:
                                          bplDetails["bpl_card_url"] != null,
                                      child: IconButton(
                                        icon: const Icon(Icons.file_present),
                                        onPressed: () async {
                                          launchUrl(Uri.parse(
                                              "${EndPoint.baseUrl}/${bplDetails["bpl_card_url"]}"));
                                        },
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
            ],
            const Gap(20),
            _queries(),
          ],
        ),
      ],
    );
  }

  Column _queries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        const AppText.heading("Queries", color: KCOLOR.brand),
        if (data["view_response_text"].toString() != "null") ...[
          const Divider(),
          Row(
            children: [
              AppText.subheading(" ${data['view_response_text']}",
                  color: KCOLOR.black),
            ],
          ),
          if (unsuccessfulMsg.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: KCOLOR.danger,
                ),
                AppText.subheading(
                  unsuccessfulMsg,
                  color: KCOLOR.danger,
                ),
              ],
            ).addPadding(bottom: 20),
          const Divider(),
          AppBtn.fill(
            "Pay",
            onPressed: () async {
              EasyLoading.show(
                  status: "Please wait",
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.black);
              var paymentOrderDetail =
                  await _service.fetchPaymentDetailForResponse(widget.rtiId);
              if (paymentOrderDetail['success']) {
                paymentOption = paymentOrderDetail["data"]['order'];
                setState(() {});

                try {
                  _razorpay.open(paymentOption);
                } catch (e) {
                  debugPrint('Error: e');
                }
              }
            },
          ),
        ],
        const Gap(5),
        citizenDetails.isEmpty
            ? _loader(height: 80)
            : ListView.builder(
                shrinkWrap: true,
                itemCount: queries.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: KCOLOR.brand.withOpacity(0.03),
                      border: const Border(
                        left: BorderSide(color: KCOLOR.brand, width: 2),
                      ),
                    ),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.subheading(queries[index]["query"]),
                          Row(
                            children: [
                              const Text(
                                "Status : ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton.icon(
                                  onPressed: () {},
                                  label: QueryStatusWidget(
                                    id: int.parse(
                                        queries[index]["query_status_id"]),
                                  )),
                            ],
                          ),
                          if (queries[index]["response"].toString() != "null" &&
                              data["can_view_response"] == "1")
                            AppBtn.outline(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        AppBtn.fill(
                                          "Close",
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                      title: const AppText.heading("Responses"),
                                      content: ViewResponsePopup(
                                        data: queries[index],
                                      ),
                                    );
                                  },
                                );
                              },
                              "View response",
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Table _education() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Highest Qualification",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["qualification"].toString())),
          ],
        ),
      ],
    );
  }

  Table _bpl() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.1),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "BPL Card No",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["bpl_card_no"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Issued",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["year_of_issue"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Issuing Authority",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(bplDetails["issuing_authority"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
      ],
    );
  }

  Table userProfile() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Name",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["name"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Email",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["email"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Phone",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["mobile_no"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Gender",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["gender"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Status",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["marital_status"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
      ],
    );
  }

  Table userAddress() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(5),
      },
      children: [
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "State",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["state"].toString())),
          ],
        ),

        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "District",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["district"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Rural/Urban",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["rural_urban"].toString())),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Address",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["address"].toString())),
          ],
        ),

        TableRow(
          children: [
            const TableCell(
                child: AppText.subheading(
              "Pincode",
            )),
            const TableCell(child: Text(":")),
            TableCell(child: Text(citizenDetails["pin_code"].toString())),
          ],
        ),

        // Add more rows for additional user profile fields
      ],
    );
  }

  Row pageHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBackTab,
            label: Text(
              "RTI Application no.  $applicationNo",
              style: const TextStyle(fontSize: 20),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("   Status:"),
            TextButton.icon(
                icon: const Icon(Icons.schedule),
                onPressed: () {},
                label: Text(
                  data["status"],
                  style: const TextStyle(fontSize: 20),
                )),
          ],
        ),
      ],
    );
  }
}
