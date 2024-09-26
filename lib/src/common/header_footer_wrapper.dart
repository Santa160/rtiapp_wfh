import 'package:flutter/material.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/footer.widget.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';

class HeaderFooterWrapper extends StatelessWidget {
  const HeaderFooterWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget().addPadding(
                top: 0,
                left: mq.width > 650 ? 88 : 0,
                right: mq.width > 650 ? 88 : 0), // default height 100
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mq.height - 180,
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
