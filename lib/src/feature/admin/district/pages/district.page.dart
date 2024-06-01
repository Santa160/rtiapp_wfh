import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/generic_data_table.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/district/logic/cubit/district_cubit.dart';
import 'package:rtiapp/src/feature/admin/district/models/res_models/district.model.dart';
import 'package:rtiapp/src/feature/user/onboarding/widgets/dropdown/state.dropdown.dart';

class DistrictPage extends StatefulWidget {
  const DistrictPage({super.key});

  @override
  State<DistrictPage> createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  var nameController = TextEditingController();
  int initialPage = 1;
  int limit = 10;

  String? _stateId;
  @override
  void initState() {
    context
        .read<DistrictCubit>()
        .getDistrictTableData(page: initialPage, limit: limit);
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = context.watch<DistrictCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(),
        const Gap(20),
        Row(
          children: [
            const Text("District"),
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
                          content: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "District Name",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: KCOLOR.brand),
                            ),
                            const SizedBox(height: 10),
                            StateDropdownForm(
                              onStateChanged: (stateid) {
                                setState(() {
                                  _stateId = stateid!["id"].toString();
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter text';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                style: const ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    backgroundColor:
                                        WidgetStatePropertyAll(KCOLOR.brand)),
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    context
                                        .read<DistrictCubit>()
                                        .addDistrict(
                                            context: context,
                                            stateId: _stateId!,
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
                        ),
                      ));
                    },
                  );
                },
                child: const Text("Add"))
          ],
        ),
        const Gap(20),
        if (state.status == Status.initial || state.status == Status.loading)
          Expanded(child: buildShimmer(state.dataColumn)),
        if (state.status == Status.error)
          const Expanded(
              child: Center(
            child: Text("No More Data Available"),
          )),
        if (state.status == Status.loaded)
          Expanded(
            child: GenericDataTable<DistrictModel>(
              initialLimit: limit,
              initialPage: initialPage,
              column: state.dataColumn,
              deleteAction: (data) {
                //
                showConfirmationDialog(
                  context: context,
                  data: data,
                  onConfirmTap: () {
                    context.read<DistrictCubit>().deleteDistrict(id: data.id);
                  },
                );
              },
              editAction: (data) {
                showUpdateFormDialog<DistrictModel>(
                  context: context,
                  data: data,
                  onUpdateTap: (newName) async {
                    context.read<DistrictCubit>().updatedDistrict(
                        id: data.id, newName: newName, stateId: data.stateId);
                  },
                );
              },
              fetchData: (limit, page) async {
                //
              },
              row: state.dataRaw!,
              loading: state.dataRaw!.isEmpty ? true : false,
            ),
          ),
        const Gap(10),
      ],
    ).addPadding(left: 50, right: 50);
  }
}
