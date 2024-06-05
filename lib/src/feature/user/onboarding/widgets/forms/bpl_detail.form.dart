import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/user/onboarding/widgets/upload/upload_file.dart';

class BPLForm extends StatefulWidget {
  final Function(Map<String, dynamic>?) bplDetails;
  final Function(FilePickerModel?) onFilePicked;
  const BPLForm({
    super.key,
    required this.belowPovertyLineformKey,
    required this.bplDetails,
    required this.onFilePicked,
  });
  final GlobalKey<FormState> belowPovertyLineformKey;

  @override
  State<BPLForm> createState() => _BPLFormState();
}

class _BPLFormState extends State<BPLForm> {
  String? _isBelowPL = 'No';

  var bplData = {
    'bpl': '1',
    'bpl_card_no': '566512',
    'year_of_issue': '1990',
    'issuing_authority': 'map'
  };

  // FormData formData = FormData.fromMap({
  //   'bpl_document': MultipartFile.fromBytes(
  //     bytes,
  //     filename: name,
  //     contentType: MediaType("kml", "kml"),
  //   ),
  // });

  _updatedbpDetails() {
    widget.bplDetails(bplData);
  }

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return Form(
        key: widget.belowPovertyLineformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText.heading(
              "Is applicant Below Poverty Line?*",
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth;
                if (mw > 800) {
                  containerWidth = constraints.maxWidth / 3;
                } else if (mw > 600) {
                  containerWidth = constraints.maxWidth / 2;
                } else {
                  containerWidth = constraints.maxWidth / 1;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio.adaptive(
                              value: "Yes",
                              groupValue: _isBelowPL,
                              onChanged: (value) {
                                setState(() {
                                  _isBelowPL = value;
                                  bplData['bpl'] = "1";
                                });
                                _updatedbpDetails();
                              },
                            ),
                            const Text("Yes")
                          ],
                        ),
                        Row(
                          children: [
                            Radio.adaptive(
                              value: "No",
                              groupValue: _isBelowPL,
                              onChanged: (value) {
                                setState(() {
                                  _isBelowPL = value;
                                  bplData['bpl'] = "0";
                                });
                                _updatedbpDetails();
                              },
                            ),
                            const Text("No")
                          ],
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        if (_isBelowPL == "Yes")
                          SizedBox(
                              width: containerWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8),
                                child: TextFormField(
                                  onChanged: (value) {
                                    bplData["bpl_card_no"] = value;
                                    _updatedbpDetails();
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter BPL card number';
                                    }
                                    if (_isBelowPL == "No") {
                                      return null;
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "BPL Card number"),
                                ),
                              )),
                        if (_isBelowPL == "Yes")
                          SizedBox(
                              width: containerWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8),
                                child: TextFormField(
                                  onChanged: (value) {
                                    bplData["year_of_issue"] = value;
                                    _updatedbpDetails();
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Issued year';
                                    }
                                    if (_isBelowPL == "No") {
                                      return null;
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Year of Issued"),
                                ),
                              )),
                        if (_isBelowPL == "Yes")
                          SizedBox(
                              width: containerWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8),
                                child: TextFormField(
                                  onChanged: (value) {
                                    bplData["issuing_authority"] = value;
                                    _updatedbpDetails();
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Issuing authority';
                                    }
                                    if (_isBelowPL == "No") {
                                      return null;
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Issuing authority"),
                                ),
                              )),
                        if (_isBelowPL == "Yes")
                          SizedBox(
                              width: containerWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Upload BPL Ration Card",
                                            style:
                                                TextStyle(color: KCOLOR.brand),
                                          ),
                                          TextSpan(
                                            text: " (Only pdf up to 1MB)",
                                            style: TextStyle(
                                              fontStyle: FontStyle
                                                  .italic, // Add desired styles here
                                              color: KCOLOR
                                                  .danger, // You can customize the color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(10),
                                    UploadFileWidget(
                                      onFilePicked: (file) {
                                        widget.onFilePicked(file);
                                        // _updatedbpDetails();
                                      },
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ],
                );
              },
            )
          ],
        ));
  }
}
