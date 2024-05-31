import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/generic_data_table.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/admin/state/logic/cubit/state_cubit.dart';
import 'package:rtiapp/src/feature/admin/state/models/res_models/state.model.dart';

class StatePage extends StatefulWidget {
  const StatePage({super.key});

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  var nameController = TextEditingController();
  int initialPage = 1;
  int limit = 10;
  @override
  void initState() {
    context
        .read<StateCubit>()
        .getStateTableData(page: initialPage, limit: limit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<StateCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(),
        const Gap(20),
        Row(
          children: [
            const Text("State"),
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
                            "State Name",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: KCOLOR.brand),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameController,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(KCOLOR.brand)),
                              onPressed: () async {
                                context
                                    .read<StateCubit>()
                                    .addState(
                                        context: context,
                                        name: nameController.text)
                                    .then((value) {
                                  Navigator.of(context).pop();

                                  nameController.clear();
                                });
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
            child: GenericDataTable<StateModel>(
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
                        .read<StateCubit>()
                        .deleteState(id: data.id);
                   
                  },
                );
              },
              editAction: (data) {
                showUpdateFormDialog<StateModel>(
                  context: context,
                  data: data,
                  onUpdateTap: (newName) async {
                    context.read<StateCubit>().updatedState(
                        id: data.id, newName: newName);
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
