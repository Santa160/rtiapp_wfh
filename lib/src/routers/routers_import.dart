import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rtiapp/src/common/feature/admin/logic/cubit/tab_cubit.dart';
import 'package:rtiapp/src/common/feature/admin/side_nav/side_nav.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/feature/admin/district/pages/district.page.dart';
import 'package:rtiapp/src/feature/admin/application/pages/application.page.dart';
import 'package:rtiapp/src/feature/admin/authentication/pages/admin_login.dart';
import 'package:rtiapp/src/feature/admin/fee/pages/fee.dart';
import 'package:rtiapp/src/feature/admin/pio/pages/pia.page.dart';
import 'package:rtiapp/src/feature/admin/qualification/pages/qualification.page.dart';
import 'package:rtiapp/src/feature/admin/query-status/pages/query.page.dart';
import 'package:rtiapp/src/feature/admin/rti-status/pages/rti.page.dart';
import 'package:rtiapp/src/feature/admin/state/pages/state.page.dart';
import 'package:rtiapp/src/feature/user/home/home.page.dart';

import 'package:rtiapp/src/feature/user/onboarding/pages/login.page.dart';
import 'package:rtiapp/src/feature/user/onboarding/pages/registration.page.dart';
import 'package:rtiapp/src/initial-setup/initial_setup.dart';

import 'package:rtiapp/src/routers/route_names.dart';

part 'routers.dart';
