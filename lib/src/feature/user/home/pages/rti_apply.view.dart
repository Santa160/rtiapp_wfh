import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';

class RtiApplyView extends StatefulWidget {
  const RtiApplyView({super.key});

  @override
  State<RtiApplyView> createState() => _RtiApplyViewState();
}

class _RtiApplyViewState extends State<RtiApplyView> {
  int count = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(index.toString()),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
                child: const FooterWidget()),
          ),
        ],
      ),
    );
  }
}
