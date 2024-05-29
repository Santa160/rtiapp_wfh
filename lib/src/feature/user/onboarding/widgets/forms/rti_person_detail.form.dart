import 'package:flutter/foundation.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/feature/user/onboarding/logic/cubit/dependent_drop_down_cubit.dart';

import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/discrict.dropdown.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/gender.dropdown.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/state.dropdown.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/marital_status.dropdown.dart';

class PersonalDetailForm extends StatefulWidget {
  final Function(Map<String, dynamic>?) personalData;
  const PersonalDetailForm({
    super.key,
    required this.personalDetailsformKey,
    required this.personalData,
  });
  final GlobalKey<FormState> personalDetailsformKey;

  @override
  State<PersonalDetailForm> createState() => _PersonalDetailFormState();
}

class _PersonalDetailFormState extends State<PersonalDetailForm> {
  Map<String, dynamic> dtoPersonalDetials = {};
  String? confirmMail;
  _updatePersonalDetails() {
    widget.personalData(dtoPersonalDetials);
  }

  var faker = Faker();

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return Form(
      key: widget.personalDetailsformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Details for RTI Applicant",
            style: style,
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
              return Wrap(
                runSpacing: 4,
                // spacing: 10,
                children: [
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            dtoPersonalDetials['email'] = value;
                            if (value.contains('@')) {
                              _updatePersonalDetails();
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: "Email *"),
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            confirmMail = value;
                            if (value.contains('@')) {
                              _updatePersonalDetails();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Email';
                            }
                            if (confirmMail != dtoPersonalDetials['email']) {
                              return "Email mismatch";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Confirm Email*",
                          ),
                        ),
                      )),
                  Visibility(
                    visible: mw > 800,
                    child: SizedBox(
                        width: containerWidth,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        )),
                  ),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            dtoPersonalDetials["name"] = value;
                            _updatePersonalDetails();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Name *",
                          ),
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            dtoPersonalDetials["address"] = value;
                            _updatePersonalDetails();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Address *",
                          ),
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: GenderDropdownForm(
                          onGenderChanged: (p0) {
                            dtoPersonalDetials["gender"] = p0;
                            _updatePersonalDetails();
                          },
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: StateDropdownForm(
                          onStateChanged: (v) {
                            dtoPersonalDetials["state_id"] = v!["id"];
                            context
                                .read<DependentDropDownCubit>()
                                .getDistrictByStateId(v["id"].toString());
                            _updatePersonalDetails();
                          },
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: DistrictDropdownForm(
                          onStateChanged: (v) {
                            dtoPersonalDetials["district_id"] = v!["id"];
                            _updatePersonalDetails();
                          },
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            dtoPersonalDetials["pin_code"] = value;
                            _updatePersonalDetails();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Pincode';
                            } else {
                              return null;
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: "Pincode"),
                        ),
                      )),
                  SizedBox(
                      width: containerWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: MaritalStatusDropdownForm(
                          onStatusChanged: (v) {
                            dtoPersonalDetials["marital_status"] = v;
                            _updatePersonalDetails();
                          },
                        ),
                      )),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
