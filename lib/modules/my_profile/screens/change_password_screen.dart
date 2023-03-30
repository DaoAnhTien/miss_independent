import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/common/utils/validator.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/my_profile/bloc/change_password_cubit.dart';
import 'package:miss_independent/modules/my_profile/bloc/change_password_state.dart';
import 'package:miss_independent/widgets/button.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/enums/status.dart';
import '../../../di/injection.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).changePassword),
        ),
        body: BlocProvider<ChangePasswordCubit>(
            create: (_) => getIt<ChangePasswordCubit>(),
            child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
              if (state.status == RequestStatus.success &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              } else if (state.status == RequestStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
            }, listenWhen: (previous, current) {
              return previous.status != current.status;
            }, builder: (BuildContext context, ChangePasswordState state) {
              return SafeArea(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        BasicTextField(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                          obscureText: !_passwordVisible,
                          controller: currentPasswordController,
                          hintText: S.of(context).enterCurrentPassword,
                          validator: Validator.passwordValidation,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BasicTextField(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _newPasswordVisible
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _newPasswordVisible = !_newPasswordVisible;
                                });
                              }),
                          obscureText: !_newPasswordVisible,
                          controller: newPasswordController,
                          hintText: S.of(context).enterNewPassword,
                          validator: Validator.passwordValidation,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BasicTextField(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              }),
                          obscureText: !_confirmPasswordVisible,
                          controller: confirmPasswordController,
                          hintText: S.of(context).confirmNewPassword,
                          validator: (String? value) =>
                              Validator.confirmPasswordValidation(
                                  value, newPasswordController.text),
                        ),
                        const Spacer(),
                        BasicButton(
                          onPressed: () {
                            _changePassword(context);
                          },
                          width: double.infinity,
                          label: S.of(context).changePassword,
                          isLoading: state.status == RequestStatus.requesting,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })));
  }

  void _changePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
            currentPasswordController.text,
            confirmPasswordController.text,
          );
    }
  }
}
