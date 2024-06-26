import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtiapp/src/app/wrapper/wrapper.dart';
import 'package:rtiapp/src/core/ktheme.dart';
import 'package:rtiapp/src/routers/routers_import.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "MSPCL RTI", //TODO Change the web title here
        routerConfig: routerConfig,
        theme: KTHEME.lightTheme(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
