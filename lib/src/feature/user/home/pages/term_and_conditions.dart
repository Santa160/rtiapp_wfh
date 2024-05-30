import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/utils/html_to_json.helper.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/user/home/service/home.service.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class TermAndConditions extends StatefulWidget {
  const TermAndConditions({super.key, required this.onCancel});

  final Function() onCancel;

  @override
  State<TermAndConditions> createState() => _TermAndConditionsState();
}

class _TermAndConditionsState extends State<TermAndConditions> {
  var title = '';
  var guidelines = [];
  var paymentModes = [];
  bool isAgreed = false;

  var service = HomeService();

  @override
  void initState() {
    getHtmlContent();

    super.initState();
  }

  getHtmlContent() async {
    var res = await service.fetchTermAndConditions();
    var htmlContent = parseHtmlToJson(res["data"]);
    title = htmlContent["title"];
    var g = htmlContent["guidelines"];
    paymentModes = htmlContent["paymentModes"];
    guidelines = [
      for (String item in g)
        if (!paymentModes.contains(item)) item
    ];
    setState(() {});
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(200),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: style,
            ),
            const Gap(10),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue, // Set border color
                  width: 2.0, // Set border width
                ),
              ),
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: guidelines.length,
                        itemBuilder: (context, index) {
                          var count = index + 1;
                          var d = guidelines[index];
                          return Text(
                            "$count.  $d",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ).addPadding(left: 150, right: 150, top: 5);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox.adaptive(
                  
                  value: isAgreed,
                  onChanged: (value) {
                    isAgreed = !isAgreed;
                    setState(() {});
                  },
                ),
                const Text(
                  "I have read and understood the above guidelines.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                   style:  ButtonStyle(
                              foregroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(isAgreed ? KCOLOR.brand : Colors.grey)),
                  onPressed: !isAgreed ? null : () {
                   Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
                const Gap(20),
                ElevatedButton(
                   style:  const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.deepOrange)),
                  onPressed: () {           
                   
                    
                    Navigator.pop(context);
                    widget.onCancel();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
