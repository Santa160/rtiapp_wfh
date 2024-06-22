import 'package:flutter/material.dart';
import 'package:rtiapp/src/core/app_config.dart';

class PaginationBtn extends StatefulWidget {
  const PaginationBtn({
    super.key,
    required this.previous,
    required this.next,
    required this.initialPage,
  });
  final Function() previous;
  final Function() next;
  final int initialPage;

  @override
  State<PaginationBtn> createState() => _PaginationBtnState();
}

class _PaginationBtnState extends State<PaginationBtn> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget
        .initialPage; // Initialize the currentPage with the initialPage from the parent
  }

  @override
  void didUpdateWidget(covariant PaginationBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage) {
      setState(() {
        currentPage = widget
            .initialPage; // Update the currentPage if the initialPage changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: widget.previous,
            label: const Text("prev")),
        AppText.heading(currentPage.toString()),
        TextButton.icon(
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: widget.next,
            label: const Text("next")),
      ],
    );
  }
}
