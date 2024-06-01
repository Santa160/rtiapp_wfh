import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/widget/serial_number.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/feature/user/home/widget/rti_status.widget.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:data_table_2/data_table_2.dart';

List<String> initialcolumn = ["id"];
int initialCoun = 0;

class RTIDataTableWidget extends StatelessWidget {
  const RTIDataTableWidget({
    super.key,
    required this.column,
    required this.fetchData,
    required this.row,
    this.editAction,
    this.deleteAction,
    this.loading = false,
    required this.initialPage,
    required this.initialLimit,
    this.viewAction,
  });

  final List<String> column;
  final Future<void> Function(int limit, int page) fetchData;
  final List<dynamic> row;
  final void Function(dynamic data)? editAction;
  final void Function(dynamic data)? deleteAction;
  final void Function(dynamic data)? viewAction;
  final int initialPage;
  final int initialLimit;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return buildShimmer(column);
    }

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DataTable2(
          isVerticalScrollBarVisible: row.length >= 10 ? true : false,
          isHorizontalScrollBarVisible: row.length >= 10 ? true : false,
          headingRowColor: const WidgetStatePropertyAll(KCOLOR.shade1),
          columns: column.map(
            (e) {
              initialCoun = row.length;
              initialcolumn = column;
              return DataColumn2(
                numeric: e == "Action",
                label: Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: Text(
                    e,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ).toList(),
          rows: row.map(
            (e) {
              return DataRow(
                  color: WidgetStateProperty.resolveWith<Color>((_) {
                    int index = row.indexOf(e);
                    return index % 2 == 0 ? KCOLOR.shade3 : KCOLOR.shade2;
                  }),
                  cells: [
                    DataCell(Text(getSerialNumber(
                            page: initialPage, index: row.indexOf(e))
                        .toString())), // Adjust as per your data model
                    DataCell(
                        Text(e["rti_no"])), // Adjust as per your data model
                    DataCell(
                        Text(e["created_at"])), // Adjust as per your data model
                    DataCell(RTIStatusWidget(
                      id: int.parse(e["status_id"]),
                    )), // Adjust as per your data model

                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              viewAction!(e);
                            },
                            child: const Text("view")),

                        // IconButton(
                        //   icon: Image.asset(KICONS.edit),
                        //   onPressed: () {
                        //     editAction(e);
                        //   },
                        // ),
                        // IconButton(
                        //   icon: Image.asset(KICONS.delete),
                        //   onPressed: () {
                        //     deleteAction(e);
                        //   },
                        // ),
                      ],
                    )),
                  ]);
            },
          ).toList(),
        ),
      ),
    );
  }
}

Widget buildShimmer(List<String> column) {
  return Shimmer(
    color: Colors.grey[300]!,
    child: Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 600,
          height: (initialCoun * 50) + 50,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Colors.grey),
            columns: column
                .map(
                  (e) => DataColumn2(
                    numeric: e == "Action",
                    label: Padding(
                      padding: const EdgeInsets.only(right: 22),
                      child: Text(e),
                    ),
                  ),
                )
                .toList(),
            rows: List.generate(
              5,
              (index) => DataRow(
                cells: [
                  DataCell(Container(height: 20)),
                  DataCell(Container(height: 20)),
                  DataCell(Container(height: 20)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

//!! ================DIALOGS===============================
typedef OnUpdateCallback = void Function(String newName);

void showUpdateFormDialog({
  required BuildContext context,
  required dynamic data,
  required OnUpdateCallback onUpdateTap,
}) {
  TextEditingController nameController = TextEditingController(text: data.name);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update ${data.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onUpdateTap(nameController.text);
              Navigator.of(context).pop();
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}

void showConfirmationDialog({
  required BuildContext context,
  required dynamic data,
  required VoidCallback onConfirmTap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmation"),
        content: Text("Are you sure you want to delete ${data.name}?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirmTap();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

//!!========================LOADER====================

// Widget buildShimmer() {
//   return Shimmer(
//     color: Colors.grey[300]!,
//     child: Card(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: SizedBox(
//           width: 600,
//           height: (initialCoun * 50) + 50,
//           child: DataTable(
//             headingRowColor: const MaterialStatePropertyAll(ksecondary),
//             columns: initialcolumn
//                 .map(
//                   (e) => DataColumn2(
//                     numeric: e == "Action",
//                     label: Padding(
//                       padding: const EdgeInsets.only(right: 22),
//                       child: Text(e),
//                     ),
//                   ),
//                 )
//                 .toList(),
//             rows: List.generate(
//               5, // You can adjust the number of shimmer rows as needed
//               (index) => DataRow(
//                 cells: [
//                   DataCell(Container(height: 20)),
//                   DataCell(Container(height: 20)),
//                   DataCell(Container(height: 20)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }