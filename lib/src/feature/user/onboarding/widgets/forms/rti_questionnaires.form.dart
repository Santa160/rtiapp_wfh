import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';

class QuestionnairesForm extends StatefulWidget {
  const QuestionnairesForm({super.key});

  @override
  State<QuestionnairesForm> createState() => _QuestionnairesFormState();
}

class _QuestionnairesFormState extends State<QuestionnairesForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RTI request application *",
            style: style,
          ),
          const Gap(10),
          TextFormField(),
          const Gap(10),
          TextFormField(),
        ],
      ),
    );
  }
}
