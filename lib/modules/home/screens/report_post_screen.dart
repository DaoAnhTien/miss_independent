import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/post.dart';
import 'package:miss_independent/modules/home/bloc/home_posts_cubit.dart';
import 'package:miss_independent/modules/home/bloc/home_posts_state.dart';

import '../../../common/enums/status.dart';
import '../../../di/injection.dart';
import '../../../widgets/button.dart';
import '../../../widgets/text_field.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/helpers/validator.dart';

class ReportPostScreen extends StatefulWidget {
  const ReportPostScreen({Key? key}) : super(key: key);

  @override
  State<ReportPostScreen> createState() => _ReportPostScreenState();
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Post? post = context.getRouteArguments<Post>();
    int? currentUserId = context.read<AuthCubit>().state.user?.id;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: kWhiteColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kPrimaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            S.of(context).report,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: kPrimaryColor),
          ),
        ),
        body: BlocProvider(
          create: (BuildContext context) => getIt<HomePostsCubit>(),
          child: BlocConsumer<HomePostsCubit, HomePostsState>(
            listenWhen: (previous, current) =>
                previous.reportPostStatus != current.reportPostStatus,
            listener: (context, state) {
              if (state.reportPostStatus == RequestStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
              if (state.reportPostStatus == RequestStatus.success) {
                showSuccessMessage(
                    context, S.of(context).reportPostSuccessfully);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      BasicTextField(
                        controller: _reasonController,
                        hintText: S
                            .of(context)
                            .writeTheReasonWhyAreYouReportingThisPost,
                        multiline: true,
                        validator: ReportValidator.reasonValidation,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      BasicButton(
                        width: double.infinity,
                        // disabled: _reasonController.text.isEmpty,
                        onPressed: () => _submitReportPost(
                            context,
                            post?.id ?? 0,
                            currentUserId ?? 0,
                            _reasonController.text),
                        label: S.of(context).report,
                        isLoading:
                            state.reportPostStatus == RequestStatus.requesting,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void _submitReportPost(
      BuildContext context, int postId, int userId, String text) {
    if (_formKey.currentState!.validate()) {
      context.read<HomePostsCubit>().reportPost(postId, userId, text);
    }
  }
}
