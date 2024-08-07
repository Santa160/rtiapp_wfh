import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/header_footer_wrapper.dart';
import 'package:rtiapp/src/common/widget/generic_data_table.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/qualification/logic/cubit/qualification_cubit.dart';
import 'package:rtiapp/src/feature/admin/qualification/models/res_models/qualification.model.dart';

class QualificationPage extends StatefulWidget {
  const QualificationPage({super.key});

  @override
  State<QualificationPage> createState() => _QualificationPageState();
}

class _QualificationPageState extends State<QualificationPage> {
  var nameController = TextEditingController();
  int initialPage = 1;
  int limit = 10;
  @override
  void initState() {
    context
        .read<QualificationCubit>()
        .getQualificationTableData(page: initialPage, limit: limit);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<QualificationCubit>().state;
    return HeaderFooterWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          _pageHeader(context),
          const Gap(20),
          if (state.status == Status.initial || state.status == Status.loading)
            buildShimmer(state.dataColumn),
          if (state.status == Status.error)
            const Expanded(
                child: Center(
              child: Text("No More Data Available"),
            )),
          if (state.status == Status.loaded)
            GenericDataTable<QualificationModel>(
              initialLimit: limit,
              initialPage: initialPage,
              column: state.dataColumn,
              deleteAction: (data) {
                //
                showConfirmationDialog(
                  context: context,
                  data: data,
                  onConfirmTap: () {
                    context
                        .read<QualificationCubit>()
                        .deleteQualification(id: data.id);
                  },
                );
              },
              editAction: (data) {
                showUpdateFormDialog<QualificationModel>(
                  context: context,
                  data: data,
                  onUpdateTap: (newName) async {
                    context
                        .read<QualificationCubit>()
                        .updatedQualification(id: data.id, newName: newName);
                  },
                );
              },
              fetchData: (limit, page) async {
                //
              },
              row: state.dataRaw!,
              loading: state.dataRaw!.isEmpty ? true : false,
            ),
          const Gap(10),
        ],
      ).addPadding(left: 50, right: 50),
    );
  }

  Row _pageHeader(BuildContext context) {
    return Row(
      children: [
        const AppText.heading("Qualification"),
        const Gap(10),
        ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(KCOLOR.brand)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Qualification",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: KCOLOR.brand),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter qualification Name';
                            }
                            return null;
                          },
                          controller: nameController,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(KCOLOR.brand)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<QualificationCubit>()
                                  .addQualification(
                                      context: context,
                                      name: nameController.text)
                                  .then((value) {
                                Navigator.of(context).pop();

                                nameController.clear();
                              });
                            }
                          },
                          child: const Row(
                            children: [
                              Expanded(child: Center(child: Text("Add"))),
                            ],
                          ))
                    ],
                  ));
                },
              );
            },
            child: const Text("Add"))
      ],
    );
  }
}
