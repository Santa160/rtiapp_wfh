import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/feature/citizen/logic/cubit/citizen_tab_cubit.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';

import 'package:rtiapp/src/core/kcolors.dart';

import 'package:rtiapp/src/routers/route_names.dart';

import '../../../../core/kassets.dart';

class CitizenSideNavPage extends StatelessWidget {
  const CitizenSideNavPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    var activeTab = context.watch<CitizenTabCubit>().state.tabName;
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget().addPadding(
              left: mw > 650 ? 150 : 50, right: mw > 650 ? 150 : 50),
          const Gap(20),
          Container(
            color: KCOLOR.brand,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<CitizenTabCubit>().activeTab(KRoutes.home);
                        context.goNamed(KRoutes.home);
                      },
                      child: Container(
                        color: Colors.white
                            .withOpacity(activeTab == KRoutes.home ? 0.2 : 0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Home",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  )),
                        ),
                      ),
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        context
                            .read<CitizenTabCubit>()
                            .activeTab(KRoutes.submitRTI);
                        context.goNamed(KRoutes.submitRTI);
                      },
                      child: Container(
                        color: Colors.white.withOpacity(
                            activeTab == KRoutes.submitRTI ? 0.2 : 0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Submit RTI",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).addPadding(left: 150, right: 150, bottom: 20),
                Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ).addPadding(left: 150, right: 150, bottom: 20),
              ],
            ),
          ),
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
          Text(
            "MSPCL RTI ${KRoutes.routeNames.length}",
            style: const TextStyle(color: Color(0xffE6E2C3), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
