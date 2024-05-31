import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/common/feature/admin/side_nav/logic/cubit/tab_cubit.dart';
import 'package:rtiapp/src/common/feature/citizen/side_nav/logic/cubit/citizen_tab_cubit.dart';
import 'package:rtiapp/src/feature/admin/state/logic/cubit/state_cubit.dart';
import 'package:rtiapp/src/feature/user/onboarding/logic/cubit/dependent_drop_down_cubit.dart';

class MultiBlocWrapper extends StatelessWidget {
  const MultiBlocWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TabCubit(),
        ),
        BlocProvider(
          create: (context) => CitizenTabCubit(),
        ),BlocProvider(
          create: (context) => StateCubit(),
        ),
        BlocProvider(
          create: (context) => DependentDropDownCubit(),
        ),
      ],
      child: child,
    );
  }
}
