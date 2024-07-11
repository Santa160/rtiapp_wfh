import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kassets.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/shared_pref.dart';
import 'package:rtiapp/src/routers/route_names.dart';
import 'package:rtiapp/src/feature/admin/authentication/service/login.service.dart';

var _auth = Auth();

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    this.height,
  });
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      height: height ?? 100,
      color: KCOLOR.brand.withOpacity(0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                KASSETS.logoVertical,
                scale: 1.5,
              ),
              const Gap(10),
            ],
          ),
          Row(
            children: [
              PopupMenuButton(
                onSelected: (value) async {
                  if (value == "Logout") {
                    var isAdmin = SharedPrefHelper.isStaff();
                    if (isAdmin ?? false) {
                      context.goNamed(KRoutes.adminlogin);
                    } else {
                      context.goNamed(KRoutes.citizenLogin);
                    }
                    await SharedPrefHelper.reset();
                  }
                  if (value == 'Change Password') {
                    handleChangePassword(context);
                  }
                },
                tooltip: '',
                child: Row(
                  children: [
                    AppText.heading(
                        "${SharedPrefHelper.getUserInfo()?.username}"),
                    const Gap(10),
                    const CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "Logout",
                      child: Text('Logout'),
                    ),
                    const PopupMenuItem(
                      value: "Change Password",
                      child: Text('Change Password'),
                    ),
                  ];
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  handleChangePassword(context) {
    showDialog(
      context: context,
      builder: (context) {
        return const ChangePasswordDialog();
      },
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      var user = SharedPrefHelper.getUserInfo();
      var res =
          await _auth.changePassword(user!.id, _newPasswordController.text);
      if (res['success']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Your password has been changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    var isAdmin = SharedPrefHelper.isStaff();
                    if (isAdmin ?? false) {
                      context.goNamed(KRoutes.adminlogin);
                    } else {
                      context.goNamed(KRoutes.citizenLogin);
                    }
                    await SharedPrefHelper.reset();
                    // Dismiss the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                hintText: "Enter new password",
                label: Text("New Password"),
              ),
              // obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                return null;
              },
            ),
            const Gap(10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                hintText: "Enter Confirm password",
                label: Text("Confirm Password"),
              ),
              // obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8.0),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _handleChangePassword,
          child: const Text('Change Password'),
        ),
      ],
    );
  }
}
