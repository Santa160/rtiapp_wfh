import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtiapp/src/feature/user/onboarding/logic/cubit/dependent_drop_down_cubit.dart';

class DependentDropdownWidget extends StatelessWidget {
  const DependentDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<DependentDropDownCubit>().state;
    return Text(state.toString());
  }
}
