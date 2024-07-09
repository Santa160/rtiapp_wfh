import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/header_footer_wrapper.dart';
import 'package:rtiapp/src/common/widget/generic_data_table.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/admin/rti-status/logic/cubit/rti_status_cubit.dart';

import '../models/res_models/rti.model.dart';

class RTIStatusPage extends StatefulWidget {
  const RTIStatusPage({super.key});

  @override
  State<RTIStatusPage> createState() => _RTIStatusPageState();
}

class _RTIStatusPageState extends State<RTIStatusPage> {
  var nameController = TextEditingController();
  int initialPage = 1;
  int limit = 10;
  @override
  void initState() {
    context
        .read<RTIStatusCubit>()
        .getRTIStatusTableData(page: initialPage, limit: limit);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<RTIStatusCubit>().state;
    return HeaderFooterWrapper(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(context),
        const Gap(20),
        if (state.status == Status.initial || state.status == Status.loading)
          buildShimmer(state.dataColumn),
        if (state.status == Status.error)
          const Center(
            child: Text("No More Data Available"),
          ),
        if (state.status == Status.loaded)
          GenericDataTable<RTIStatusModel>(
            initialLimit: limit,
            initialPage: initialPage,
            column: state.dataColumn,
            deleteAction: (data) {
              //
              showConfirmationDialog(
                context: context,
                data: data,
                onConfirmTap: () {
                  context.read<RTIStatusCubit>().deleteRTIStatus(id: data.id);
                },
              );
            },
            editAction: (data) {
              showUpdateFormDialog<RTIStatusModel>(
                context: context,
                data: data,
                onUpdateTap: (newName) async {
                  context
                      .read<RTIStatusCubit>()
                      .updatedRTIStatus(id: data.id, newName: newName);
                },
              );
            },
            fetchData: (limit, page) async {
              //
            },
            row: state.dataRaw!,
            loading: state.dataRaw!.isEmpty ? true : false,
          )
      ],
    ).addPadding(left: 50, right: 50));
  }

  _pageHeader(BuildContext context) {
    return Row(
      children: [
        const AppText.heading("RTI Status"),
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
                        "RTI Status Name",
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
                              return 'Please enter RTI Status Name';
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
                                  .read<RTIStatusCubit>()
                                  .addRTIStatus(
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
