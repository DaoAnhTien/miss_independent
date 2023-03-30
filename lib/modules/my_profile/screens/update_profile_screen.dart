import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/data/remote/auth/request_models/update_profile_request.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/modules/auth/helpers/validator.dart';
import 'package:miss_independent/modules/my_profile/bloc/edit_profile_cubit.dart';
import 'package:miss_independent/modules/my_profile/bloc/edit_profile_state.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/enums/status.dart';
import '../../../di/injection.dart';
import '../../../generated/l10n.dart';
import '../../../models/user.dart';
import '../../../widgets/button.dart';
import '../../../widgets/upload_image_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userNameController = TextEditingController()
    ..text = _user?.name ?? '';
  late final TextEditingController _businessNameController =
      TextEditingController()..text = _user?.businessName ?? '';
  late final TextEditingController _businessEmailController =
      TextEditingController()..text = _user?.businessEmail ?? '';
  late final TextEditingController _aboutMeController = TextEditingController()
    ..text = _user?.aboutMe ?? '';

  late final TextEditingController _tiktokController = TextEditingController()
    ..text = _user?.socialLinkTiktok ?? '';
  late final TextEditingController _fbController = TextEditingController()
    ..text = _user?.socialLinkFacebook ?? '';
  late final TextEditingController _twitterController = TextEditingController()
    ..text = _user?.socialLinkTwitter ?? '';
  late final TextEditingController _instagramController =
      TextEditingController()..text = _user?.socialLinkInstagram ?? '';
  late final TextEditingController _youtubeController = TextEditingController()
    ..text = _user?.socialLinkYoutube ?? '';
  late final TextEditingController _websiteController = TextEditingController()
    ..text = _user?.websiteLink ?? '';

  User? get _user => context.read<AuthCubit>().state.user;

  XFile? _file;
  bool _isShowImageFile = false;

  UpdateProfileRequest updateProfileRequest = UpdateProfileRequest.empty();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              S.of(context).editProfile,
            ),
          ),
          body: BlocProvider(
            create: (_) => getIt<EditProfileCubit>()..init(_user),
            child: BlocConsumer<EditProfileCubit, EditProfileState>(
              listenWhen:
                  (EditProfileState previous, EditProfileState current) =>
                      previous.status != current.status,
              listener: (context, EditProfileState state) {
                if (state.status == RequestStatus.failed &&
                    state.message?.isNotEmpty == true) {
                  showErrorMessage(context, state.message!);
                }
                if (state.status == RequestStatus.success) {
                  showSuccessMessage(
                      context, S.of(context).updateProfileSuccessfully);
                  Navigator.of(context).pop();
                }
              },
              builder: (context, EditProfileState state) {
                return SafeArea(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UploadImageProfile(
                                  file: state.user?.image,
                                  isShowImageFile: _isShowImageFile,
                                  xFile: _file,
                                  onChanged: (XFile? file) {
                                    if (file != null) {
                                      setState(() {
                                        _file = file;
                                        _isShowImageFile = true;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            BasicTextField(
                              label: S.of(context).businessName,
                              controller: _businessNameController,
                              mandatory: true,
                              validator:
                                  CreateProfileValidator.businessNameValidation,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              mandatory: true,
                              label: S.of(context).fullName,
                              controller: _userNameController,
                              validator: CreateProfileValidator.nameValidation,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              label: S.of(context).businessEmail,
                              controller: _businessEmailController,
                              validator: CreateProfileValidator
                                  .businessEmailValidation,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              mandatory: true,
                              controller: _aboutMeController,
                              label: S.of(context).aboutMe,
                              multiline: true,
                              validator:
                                  CreateProfileValidator.aboutMeValidation,
                            ),
                            const SizedBox(height: 15),
                            Text(S.of(context).websiteSocialMedia,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 15),
                            BasicTextField(
                              hintText: "tiktok_id",
                              controller: _tiktokController,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              label: 'Tiktok',
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              hintText: "fb_id",
                              label: 'Facebook',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              controller: _fbController,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              hintText: "twitter_id",
                              label: 'Twitter',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              controller: _twitterController,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              hintText: "instagram_id",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              controller: _instagramController,
                              label: 'Instagram',
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              hintText: "youtube_id",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              label: 'Youtube',
                              controller: _youtubeController,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              hintText: "missindependentme.com",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: kGreyColor),
                              label: 'Website',
                              controller: _websiteController,
                            ),
                            const SizedBox(height: 10),
                            BasicButton(
                                width: double.infinity,
                                onPressed: () {
                                  _submitEdit(context);
                                },
                                label: S.of(context).editProfile,
                                isLoading:
                                    state.status == RequestStatus.requesting),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }

  void _submitEdit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await context
          .read<EditProfileCubit>()
          .editProfile(updateProfileRequest.copyWith(
            image: _file,
            aboutMe: _aboutMeController.text,
            businessEmail: _businessEmailController.text,
            businessName: _businessNameController.text,
            instagram: _instagramController.text,
            youtube: _youtubeController.text,
            tiktok: _tiktokController.text,
            website: _websiteController.text,
            twitter: _twitterController.text,
            facebook: _fbController.text,
            name: _userNameController.text,
          ));
    }
  }
}
