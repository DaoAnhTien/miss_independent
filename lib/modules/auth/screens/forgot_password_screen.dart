import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/enums/status.dart';
import '../../../common/utils/validator.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/button.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
              prev.forgotPassStatus != current.forgotPassStatus,
          listener: (context, AuthState state) {
            if (state.forgotPassStatus == RequestStatus.failed &&
                (state.forgotPassMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.forgotPassMessage!);
            } else if (state.forgotPassStatus == RequestStatus.success) {
              showSuccessMessage(context, S.of(context).newPasswordSent);
              Navigator.of(context).pop();
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
                        Text(S
                            .of(context)
                            .forgotPassword
                            .toString()
                            .toUpperCase()),
                        const SizedBox(height: 10),
                        Text('MISS INDEPENDENT',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 20),
                        Text(S.of(context).forgotPassDesc,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        BasicTextField(
                          controller: _emailController,
                          label: S.of(context).email,
                          validator: Validator.emailValidation,
                        ),
                        const SizedBox(height: 10),
                        BasicButton(
                            width: double.infinity,
                            onPressed: () {
                              _submitLogin(context);
                            },
                            label: S.of(context).sendEmail,
                            isLoading: state.forgotPassStatus ==
                                RequestStatus.requesting),
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

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(_emailController.text);
    }
  }
}
