import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/common/widget/hint_text.dart';

import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/user/onboarding/service/onboarding.service.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/forms/bpl_detail.form.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/forms/education_details.form.dart';

import 'package:rtiapp/src/feature/user/onboarding/widgets/forms/rti_person_detail.form.dart';
import 'package:rtiapp/src/routers/route_names.dart';

class ResgistrationPage extends StatefulWidget {
  const ResgistrationPage({super.key});

  @override
  State<ResgistrationPage> createState() => _ResgistrationPageState();
}

class _ResgistrationPageState extends State<ResgistrationPage> {
  final personalDetailsformKey = GlobalKey<FormState>();
  final belowPovertyLineformKey = GlobalKey<FormState>();

  Map<String, dynamic> citizenDto = {
    // 'name': 'John',
    // 'email': 'john@ee.com',
    // 'state_id': '1',
    // 'district_id': '1',
    // 'pin_code': '795002',
    // 'address': 'asd',
    // 'gender': 'male',
    // 'marital_status': 'married',
    'education_status': 0,
    'qualification_id': 3,
    'bpl': 0,
    // 'bpl_card_no': '566512',
    // 'year_of_issue': '1990',
    // 'issuing_authority': 'map'
  };
  FilePickerModel? _file;

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HeaderWidget().addPadding(
              left: mw > 650 ? 150 : 50, right: mw > 650 ? 150 : 50),
          const Gap(20),
          Container(
            color: KCOLOR.brand,
            child: Row(
              children: [
                Text(
                  "Home",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const Gap(20),
                Text(
                  "Submit RTI",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ).addPadding(left: 150, right: 150, bottom: 20),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Citizen Registration Form",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  hintText("Note: Fields mark with ", " are Mandatory. "),
                  const Gap(20),
                  PersonalDetailForm(
                    personalDetailsformKey: personalDetailsformKey,
                    personalData: (data) {
                      citizenDto.addAll({...data!});
                    },
                  ),
                  BPLForm(
                    bplDetails: (bplDetails) {
                      citizenDto.addAll({...bplDetails!});
                    },
                    belowPovertyLineformKey: belowPovertyLineformKey,
                    onFilePicked: (file) {
                      logger.e(file!.fileName);
                      _file = file;
                    },
                  ),
                  const Gap(10),
                  EducationForm(
                    educationDetails: (eduQ) {
                      citizenDto.addAll({...eduQ!});
                    },
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () {}, child: const Text("Reset")),
                      ElevatedButton(
                          style: const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(KCOLOR.brand)),
                          onPressed: () async {
                          
                            if (validate()) {
                              var service = OnboardingServices();
                             var res = await service.createCitizen(citizenDto, _file);
                             if (res["success"]) {
                             context.replaceNamed(KRoutes.home);  
                             }
                            }else{
                              logger.e("check please");
                            }
                          },
                          child: const Text("Submit"))
                    ],
                  ),
                  const Gap(10),
                ],
              ).addPadding(
                  left: mw > 650 ? 150 : 50, right: mw > 650 ? 150 : 50),
            ),
          ),
        ],
      ),
    );
  }

  bool validate() {
    if (personalDetailsformKey.currentState!.validate() &&
        belowPovertyLineformKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
