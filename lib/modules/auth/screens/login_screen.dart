import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/constants/routes.dart';
import '../../../common/enums/status.dart';
import '../../../common/utils/validator.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/button.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (AuthState prev, AuthState current) =>
              prev.loginStatus != current.loginStatus,
          listener: (context, AuthState state) {
            if (state.loginStatus == RequestStatus.failed &&
                (state.loginMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.loginMessage!);
            } else if (state.loginStatus == RequestStatus.success &&
                state.isInActive == false) {
              Navigator.of(context).pushNamed(kVerifyEmailRoute);
            } else if (state.loginStatus == RequestStatus.success &&
                state.isNotCreatedProfile == false) {
              Navigator.of(context).pushNamed(kCreateProfileRoute);
            } else if (state.loginStatus == RequestStatus.success &&
                (state.token?.isNotEmpty ?? false)) {
              Navigator.of(context).pushNamed(kMainRoute);
            }
          },
          builder: (context, AuthState state) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: 100, child: CachedImage(url: iconFly)),
                          const SizedBox(height: 10),
                          Text(S.of(context).loginTo.toString().toUpperCase()),
                          const SizedBox(height: 10),
                          Text('MISS INDEPENDENT',
                              style: Theme.of(context).textTheme.displaySmall),
                          const SizedBox(height: 30),
                          BasicTextField(
                            controller: emailController,
                            label: S.of(context).email,
                            validator: Validator.emailValidation,
                          ),
                          const SizedBox(height: 10),
                          BasicTextField(
                            controller: passwordController,
                            labelWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).password,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, kForgotPasswordRoute);
                                  },
                                  child: Text(
                                    "${S.of(context).forgotPassword}?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                            obscureText: true,
                            validator: Validator.passwordValidation,
                          ),
                          const SizedBox(height: 10),
                          BasicButton(
                              width: double.infinity,
                              onPressed: () {
                                _submitLogin(context);
                              },
                              label: S.of(context).login,
                              isLoading: state.loginStatus ==
                                  RequestStatus.requesting),
                          const SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                                text: S.of(context).dontHaveAnAccount,
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: " ${S.of(context).signUp}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed(kSignUpRoute),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthCubit>()
          .login(emailController.text, passwordController.text, null);
    }
  }
}
