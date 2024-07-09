import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/header_footer_wrapper.dart';
import 'package:rtiapp/src/common/widget/generic_data_table.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/feature/admin/query-status/logic/cubit/query_cubit.dart';
import 'package:rtiapp/src/feature/admin/query-status/models/res_models/query.model.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  var nameController = TextEditingController();
  int initialPage = 1;
  int limit = 10;
  @override
  void initState() {
    context
        .read<QueryCubit>()
        .getQueryTableData(page: initialPage, limit: limit);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = context.watch<QueryCubit>().state;
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
            const Center(
              child: Text("No More Data Available"),
            ),
          if (state.status == Status.loaded)
            GenericDataTable<QueryModel>(
              initialLimit: limit,
              initialPage: initialPage,
              column: state.dataColumn,
              deleteAction: (data) {
                //
                showConfirmationDialog(
                  context: context,
                  data: data,
                  onConfirmTap: () {
                    context.read<QueryCubit>().deleteQuery(id: data.id);
                  },
                );
              },
              editAction: (data) {
                showUpdateFormDialog<QueryModel>(
                  context: context,
                  data: data,
                  onUpdateTap: (newName) async {
                    context
                        .read<QueryCubit>()
                        .updatedQuery(id: data.id, newName: newName);
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
        const AppText.heading("Query"),
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
                        "Query Name",
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
                              return 'Please enter Query Status Name';
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
                                  .read<QueryCubit>()
                                  .addQuery(
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
