import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/post_comments/bloc/report_comment_cubit.dart';
import 'package:miss_independent/modules/post_comments/bloc/report_comment_state.dart';

import '../../../common/enums/status.dart';
import '../../../di/injection.dart';
import '../../../widgets/button.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/text_field.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/helpers/validator.dart';

class ReportCommentScreen extends StatefulWidget {
  const ReportCommentScreen({Key? key}) : super(key: key);

  @override
  State<ReportCommentScreen> createState() => _ReportCommentScreenState();
}

class _ReportCommentScreenState extends State<ReportCommentScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = context.getRouteArguments();
    final User? currentUser = context.read<AuthCubit>().state.user;
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
          create: (BuildContext context) =>
              getIt<ReportCommentCubit>()..init(args['comment'], args['args']),
          child: BlocConsumer<ReportCommentCubit, ReportCommentState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == RequestStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
              if (state.status == RequestStatus.success) {
                showSuccessMessage(
                    context, S.of(context).reportCommentSuccessfully);
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: kLightGreyColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedImage(
                                url: state.comment?.user?.image,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                radius: 25),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.comment?.user?.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${state.comment?.createdAt?.toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: kGreyColor),
                                  ),
                                  Text(
                                    state.comment?.text ?? "",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      BasicTextField(
                        controller: _reasonController,
                        hintText: S
                            .of(context)
                            .writeTheReasonWhyAreYouReportingThisComment,
                        multiline: true,
                        validator: ReportValidator.reasonValidation,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      BasicButton(
                        width: double.infinity,
                        // disabled: _reasonController.text.isEmpty,
                        onPressed: () => _submitReport(
                            context,
                            currentUser?.id ?? 0,
                            _reasonController.text,
                            currentUser?.email ?? ""),
                        label: S.of(context).report,
                        isLoading: state.status == RequestStatus.requesting,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  void _submitReport(
      BuildContext context, int userId, String text, String email) {
    if (_formKey.currentState!.validate()) {
      context.read<ReportCommentCubit>().reportComment(userId, text, email);
    }
  }
}
