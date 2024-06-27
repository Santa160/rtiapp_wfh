import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:rtiapp/src/core/kcolors.dart';



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
                        itemCount: sideNavItesm.length,
                        itemBuilder: (context, index) {
                          var title = sideNavItesm[index].title;
                          return Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: activeTab == sideNavItesm[index].title
                                  ? KCOLOR.shade3.withOpacity(0.1)
                                  : null,
                            ),
                            child: title == KRoutes.setting
                                ? ExpansionTile(
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    title: Text(
                                      title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    children: [
                                      ...sideNavItesm[index].subRoute!.map(
                                        (e) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: activeTab == e.title
                                                  ? KCOLOR.shade3
                                                      .withOpacity(0.1)
                                                  : null,
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                context
                                                    .read<TabCubit>()
                                                    .activeTab(e.title);

                                                context.goNamed(e.title);
                                              },
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 30,
                                                      top: 0,
                                                      bottom: 0),
                                              title: Text(
                                                e.title,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : ListTile(
                                    onTap: () {
                                      context
                                          .read<TabCubit>()
                                          .activeTab(sideNavItesm[index].title);

                                      context
                                          .goNamed(sideNavItesm[index].title);
                                    },
                                    title: Text(
                                      sideNavItesm[index].title,
                                      style: TextStyle(
                                          color: activeTab ==
                                                  KRoutes.routeNames[index]
                                              ? Colors.white
                                              : Colors.white),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await SharedPrefHelper.removeToken("token");
                    //     context.goNamed(KRoutes.adminlogin);
                    //   },
                    //   child: const SizedBox(
                    //       width: 100,
                    //       child: Text(
                    //         "Logout",
                    //         style: TextStyle(color: Colors.white),
                    //       )),
                    // ),
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
