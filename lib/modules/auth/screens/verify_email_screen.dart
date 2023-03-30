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
import '../../../generated/l10n.dart';
import '../../../widgets/button.dart';
import '../../../widgets/loading_indicator.dart';
import '../bloc/auth_state.dart';
import '../helpers/validator.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

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
              prev.verifyStatus != current.verifyStatus ||
              prev.resendStatus != current.resendStatus,
          listener: (context, AuthState state) {
            if (state.verifyStatus == RequestStatus.failed &&
                (state.verifyMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.verifyMessage!);
            } else if (state.verifyStatus == RequestStatus.success &&
                (state.token?.isNotEmpty ?? false)) {
              Navigator.of(context).pushNamed(kCreateProfileRoute);
            } else if (state.resendStatus == RequestStatus.failed &&
                (state.resendMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.resendMessage!);
            } else if (state.resendStatus == RequestStatus.success) {
              showSuccessMessage(context, S.of(context).verifyCodeSentSuccess);
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
                            .verifyYourEmail
                            .toString()
                            .toUpperCase()),
                        const SizedBox(height: 10),
                        Text('MISS INDEPENDENT',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 20),
                        Text(S.of(context).verifyEmailDesc,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        BasicTextField(
                          controller: _codeController,
                          label: S.of(context).verificationCode,
                          validator: VerifyEmailValidator.codeValidation,
                        ),
                        const SizedBox(height: 10),
                        BasicButton(
                            width: double.infinity,
                            onPressed: () {
                              _submitLogin(context);
                            },
                            label: S.of(context).verifyCode,
                            isLoading:
                                state.verifyStatus == RequestStatus.requesting),
                        if (state.resendStatus != RequestStatus.requesting)
                          GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().resendVerifyCode();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                S.of(context).resendVerifyCode,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.blue),
                              ),
                            ),
                          ),
                        if (state.resendStatus == RequestStatus.requesting)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: LoadingIndicator(),
                          )
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
      context.read<AuthCubit>().verifyEmail(_codeController.text);
    }
  }
}
