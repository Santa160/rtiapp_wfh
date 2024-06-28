import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/eduq.dropdown.dart';

class EducationForm extends StatefulWidget {
  const EducationForm(
      {super.key,
      required this.educationDetails,
      required this.educationFormKey});
  final Function(Map<String, dynamic>?) educationDetails;
  final GlobalKey<FormState> educationFormKey;

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  var eduQ = {
    'education_status': 'Literate',
    'qualification_id': '',
  };
  _updatedEduQDetails() {
    widget.educationDetails(eduQ);
  }

  @override
  void initState() {
    _updatedEduQDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth;
        if (mw > 800) {
          containerWidth = constraints.maxWidth / 3;
        } else if (mw > 600) {
          containerWidth = constraints.maxWidth / 2;
        } else {
          containerWidth = constraints.maxWidth / 1;
        }
        return SizedBox(
            width: containerWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText.heading(
                    "Education Status",
                  ),
                  EduQDropdownForm(
                    educationForm: widget.educationFormKey,
                    onEduQChanged: (value) {
                      eduQ["education_status"] = value!["education_status"];
                      eduQ["qualification_id"] = value["qualification_id"];
                      _updatedEduQDetails();
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
