import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/header_footer_wrapper.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/admin/application/services/fees.service.dart';

var _service = FeeService();

class FeePage extends StatefulWidget {
  const FeePage({super.key});

  @override
  State<FeePage> createState() => _FeePageState();
}

class _FeePageState extends State<FeePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _feecontroller = TextEditingController();
  TextEditingController _chargecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFee();
  }

  // String msg = 'Update successful!';
  String id = '';

  getFee() async {
    try {
      var feeRes = await _service.fetchFeeAmount();
      if (feeRes["success"]) {
        _feecontroller =
            TextEditingController(text: feeRes['data']["amount"].toString());
        _chargecontroller = TextEditingController(
            text: feeRes['data']["amount_per_page"].toString());
        id = feeRes['data']['id'].toString();
        setState(() {});
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderFooterWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          const AppText.heading(
            "Fees And Charges",
            color: KCOLOR.brand,
          ),
          const Gap(20),
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText.subheading("RTI Fee Charge"),
                  const Gap(10),
                  TextFormField(
                    // initialValue: "$initialfee",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-99999999]'))
                    ],
                    controller: _feecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter amount';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  const AppText.subheading("Extra Pages Charge"),
                  const Gap(10),
                  TextFormField(
                    // initialValue: "$initialfee",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-99999999]'))
                    ],
                    keyboardType: TextInputType.number,
                    controller: _chargecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter amount';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      AppBtn.fill(
                        "Save",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var res = await _service.updateFeesAndChargesAmount(
                                id,
                                newFeeAmount: _feecontroller.text,
                                newChargeAmount: _chargecontroller.text);
                            if (res['success']) {
                              EasyLoading.showSuccess(
                                  res["message"] ?? "Successfully Updated");
                            }
                          }
                        },
                      )
                    ],
                  )
                ],
              )),
        ],
      ).addPadding(left: 50, right: 50),
    );
  }
}
