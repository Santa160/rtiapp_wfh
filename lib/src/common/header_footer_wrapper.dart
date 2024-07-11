import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';


class HeaderFooterWrapper extends StatelessWidget {
  const HeaderFooterWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(), // default height 100
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mq - 180,
              ),
              child: child,
            ),
            const FooterWidget() // default height 80
          ],
        ),
      ),
    );
  }
}
