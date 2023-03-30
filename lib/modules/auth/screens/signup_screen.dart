import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (AuthState prev, AuthState current) =>
              prev.signUpStatus != current.signUpStatus,
          listener: (context, AuthState state) {
            if (state.signUpStatus == RequestStatus.failed &&
                (state.signUpMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.signUpMessage!);
            } else if (state.signUpStatus == RequestStatus.success &&
                (state.token?.isNotEmpty ?? false)) {
              Navigator.of(context).pushNamed(kVerifyEmailRoute);
            }
          },
          builder: (context, AuthState state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const SizedBox(
                            height: 100, child: CachedImage(url: iconFly)),
                        const SizedBox(height: 10),
                        Text(S.of(context).signUpTo.toString().toUpperCase()),
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
                          label: S.of(context).password,
                          obscureText: true,
                          validator: Validator.passwordValidation,
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          controller: confirmPasswordController,
                          label: S.of(context).confirmPassword,
                          obscureText: true,
                          validator: (String? value) =>
                              Validator.confirmPasswordValidation(
                                  value, passwordController.text),
                        ),
                        const SizedBox(height: 10),
                        SelectDateTextField(
                          controller: datePickerController,
                          label: S.of(context).dateOfBirth,
                          value: datePickerController.text.isNotEmpty
                              ? DateFormat("yyyy-MM-dd")
                                  .parse(datePickerController.text)
                              : DateTime.now(),
                          onChanged: _onChangedDateOfBirth,
                          validator: Validator.dateOfBirthValidation,
                        ),
                        const SizedBox(height: 10),
                        BasicButton(
                            width: double.infinity,
                            onPressed: () {
                              _submitLogin(context);
                            },
                            label: S.of(context).signUp,
                            isLoading:
                                state.signUpStatus == RequestStatus.requesting),
                      ],
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

  void _onChangedDateOfBirth(DateTime? dateTime) {
    datePickerController.text = dateTime?.toYYYYMMDDString() ?? '';
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(emailController.text,
          passwordController.text, datePickerController.text, 'abc');
    }
  }
}
