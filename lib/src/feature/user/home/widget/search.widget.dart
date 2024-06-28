import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/kcolors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.onTab});
  final Function(dynamic) onTab;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: KCOLOR.brand),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        constraints: const BoxConstraints(
          minWidth: 100.0, // Minimum width
          maxWidth: 300.0, // Maximum width
          minHeight: 50.0, // Minimum height
          maxHeight: 200.0, // Maximum height
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  child: TextFormField(
                    onEditingComplete: () {
                      widget.onTab(searchController.text);
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search by rti application number",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                minHeight: 50.0, // Minimum height
                maxHeight: 200.0, // Maximum height
              ),
              color: KCOLOR.brand,
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    widget.onTab(searchController.text);
                  }
                },
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
