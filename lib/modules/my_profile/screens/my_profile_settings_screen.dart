import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';

import '../../../common/constants/routes.dart';
import '../../../common/theme/colors.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../auth/bloc/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) => SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed(kEditProfileRoute),
                        title: Text(
                          S.of(context).editProfile,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        )),
                  ),
                  Card(
                    child: ListTile(
                        onTap: () => Navigator.of(context)
                            .pushNamed(kChangePasswordRoute),
                        title: Text(
                          S.of(context).changePassword,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        )),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        customAppDialog(
                          context,
                          title: S.of(context).deactivateAccount,
                          icon: const Icon(
                            Icons.warning_amber_rounded,
                            color: kErrorRedColor,
                            size: 50,
                          ),
                          textConfirmColor: kErrorRedColor,
                          text: S.of(context).areYouSureToDeactivateYourAccount,
                          onConfirm: () {
                            _deactivateAccount(context);
                          },
                        );
                      },
                      title: Text(
                        S.of(context).deactivateAccount,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: kErrorRedColor),
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }

  void _deactivateAccount(BuildContext context) async {
    bool isSuccess = await context.read<AuthCubit>().deactivateAccount();
    if (context.mounted) {
      if (isSuccess) {
        Navigator.of(context).pushReplacementNamed(kLoginRoute);
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          showErrorMessage(
              context, context.read<AuthCubit>().state.deactivateMessage ?? "");
        }
      }
    }
  }
}
