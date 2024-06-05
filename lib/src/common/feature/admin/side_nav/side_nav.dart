import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/core/shared_pref.dart';

import 'package:rtiapp/src/routers/route_names.dart';

import '../../../../core/kassets.dart';
import '../logic/cubit/tab_cubit.dart';

class SideNavPage extends StatelessWidget {
  const SideNavPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var activeTab = context.watch<TabCubit>().state.tabName;
    return Scaffold(
      body: Row(
        children: [
          if (w > 1100)
            Container(
                height: double.infinity,
                width: 250,
                color: KCOLOR.brand,
                child: Column(
                  children: [
                    sideNavLogo(),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: KRoutes.routeNames.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: activeTab == KRoutes.routeNames[index]
                                  ? KCOLOR.shade3.withOpacity(0.1)
                                  : null,
                              // border: Border(
                              //   left: activeTab == KRoutes.routeNames[index]
                              //       ? const BorderSide(
                              //           width: 5, color: Colors.red)
                              //       : const BorderSide(),
                              // ),
                            ),
                            child: ListTile(
                              onTap: () {
                                context
                                    .read<TabCubit>()
                                    .activeTab(KRoutes.routeNames[index]);

                                context.goNamed(KRoutes.routeNames[index]);
                              },
                              title: Text(
                                KRoutes.routeNames[index],
                                style: TextStyle(
                                    color:
                                        activeTab == KRoutes.routeNames[index]
                                            ? Colors.white
                                            : Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await SharedPrefHelper.removeToken("token");
                        context.goNamed(KRoutes.adminlogin);
                      },
                      child: const SizedBox(
                          width: 100,
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )),
          Expanded(child: child)
        ],
      ),
    );
  }

  Widget sideNavLogo() {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            child: Image.asset(
              KASSETS.logo,
              fit: BoxFit.contain,
              scale: 1,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "MSPCL RTI",
            style: TextStyle(color: Color(0xffE6E2C3), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
