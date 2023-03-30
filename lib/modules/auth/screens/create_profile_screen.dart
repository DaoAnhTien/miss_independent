import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/data/remote/auth/request_models/create_profile_request.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/modules/auth/helpers/validator.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/constants/countries.dart';
import '../../../common/constants/routes.dart';
import '../../../common/enums/status.dart';
import '../../../configs/build_config.dart';
import '../../../generated/l10n.dart';
import '../../../models/category.dart';
import '../../../models/user.dart';
import '../../../widgets/button.dart';
import '../../../widgets/upload_image_profile.dart';
import '../../common/screens/webview_screen.dart';
import '../bloc/auth_state.dart';
import '../widgets/checkbox_item.dart';
import '../widgets/multi_select_categories.dart';
import '../widgets/select_item.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  CreateProfileRequest _createProfileRequest = CreateProfileRequest.empty();
  bool _readTerms = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AuthCubit>().getCategories();
    });
  }

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
          centerTitle: true,
          title: Text(S.of(context).createProfile,
              style: Theme.of(context).textTheme.displaySmall),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (AuthState prev, AuthState current) =>
              prev.createProfileStatus != current.createProfileStatus,
          listener: (context, AuthState state) {
            if (state.createProfileStatus == RequestStatus.failed &&
                (state.createProfileMessage?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.createProfileMessage!);
            } else if (state.createProfileStatus == RequestStatus.success &&
                (state.token?.isNotEmpty ?? false)) {
              Navigator.of(context).pushNamed(kMainRoute);
            }
          },
          builder: (context, AuthState state) {
            final bool isCategoriesVisible =
                state.generalCategories?.isNotEmpty ?? false;
            final bool isServiceProvider =
                _createProfileRequest.membershipType ==
                        MembershipType.serviceProvider.rawValue &&
                    (state.softCategories?.isNotEmpty ?? false);

            final bool isCoaching = _createProfileRequest.membershipType ==
                    MembershipType.serviceProvider.rawValue &&
                _createProfileRequest.serviceProviderType ==
                    ServiceProviderType.coachMentor.rawValue &&
                (state.coachingCategories?.isNotEmpty ?? false);

            final bool isConsultantTrainer =
                _createProfileRequest.membershipType ==
                        MembershipType.serviceProvider.rawValue &&
                    _createProfileRequest.serviceProviderType ==
                        ServiceProviderType.consultantTrainer.rawValue &&
                    (state.serviceCategories?.isNotEmpty ?? false);

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
                              file: _createProfileRequest.image?.path,
                              onChanged: (XFile? file) {
                                setState(() {
                                  _createProfileRequest = _createProfileRequest
                                      .copyWith(image: file);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SelectTextField(
                          value: _createProfileRequest.membershipType,
                          label: S.of(context).membershipType,
                          onChanged: (String? value) {
                            setState(() {
                              _createProfileRequest = _createProfileRequest
                                  .copyWith(membershipType: value);
                            });
                          },
                          items: MembershipType.values
                              .map((e) => SelectTextFieldArg(
                                  label: e.displayName, value: e.rawValue))
                              .toList(),
                        ),
                        if (_createProfileRequest.membershipType ==
                            MembershipType.serviceProvider.rawValue)
                          const SizedBox(height: 10),
                        if (_createProfileRequest.membershipType ==
                            MembershipType.serviceProvider.rawValue)
                          SelectTextField(
                            value: _createProfileRequest.serviceProviderType,
                            label: S.of(context).selectServiceProviderType,
                            onChanged: (String? value) {
                              setState(() {
                                _createProfileRequest = _createProfileRequest
                                    .copyWith(serviceProviderType: value);
                              });
                            },
                            items: ServiceProviderType.values
                                .map((e) => SelectTextFieldArg(
                                    label: e.displayName, value: e.rawValue))
                                .toList(),
                          ),
                        if (_createProfileRequest.membershipType !=
                            MembershipType.tulip.rawValue)
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              BasicTextField(
                                controller: _businessNameController,
                                label: S.of(context).businessName,
                                mandatory: true,
                                validator: CreateProfileValidator
                                    .businessNameValidation,
                              ),
                              const SizedBox(height: 10),
                              BasicTextField(
                                controller: _businessEmailController,
                                label: S.of(context).businessEmail,
                                validator: CreateProfileValidator
                                    .businessEmailValidation,
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          mandatory: true,
                          controller: _nameController,
                          label: S.of(context).fullName,
                          validator: CreateProfileValidator.nameValidation,
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          mandatory: true,
                          controller: _aboutMeController,
                          label: S.of(context).aboutMe,
                          multiline: true,
                          validator: CreateProfileValidator.aboutMeValidation,
                        ),
                        if (isCategoriesVisible) const SizedBox(height: 10),
                        if (isCategoriesVisible)
                          MultiSelectCategoriesField(
                            label: S.of(context).categories,
                            categories: state.generalCategories ?? [],
                            selectedItems: _createProfileRequest
                                    .selectedGeneralCategories ??
                                [],
                            onSelected: (List<Category> items) {
                              setState(() {
                                _createProfileRequest = _createProfileRequest
                                    .copyWith(selectedGeneralCategories: items);
                              });
                            },
                          ),
                        if (isServiceProvider) const SizedBox(height: 10),
                        if (isServiceProvider)
                          MultiSelectCategoriesField(
                            label: S
                                .of(context)
                                .softSkillsCoachingTrainingCategories,
                            categories: state.softCategories ?? [],
                            selectedItems:
                                _createProfileRequest.selectedSoftCategories ??
                                    [],
                            onSelected: (List<Category> items) {
                              setState(() {
                                _createProfileRequest = _createProfileRequest
                                    .copyWith(selectedSoftCategories: items);
                              });
                            },
                          ),
                        if (isCoaching) const SizedBox(height: 10),
                        if (isCoaching)
                          MultiSelectCategoriesField(
                            label: S.of(context).coachMentorCategories,
                            categories: state.coachingCategories ?? [],
                            selectedItems: _createProfileRequest
                                    .selectedCoachingCategories ??
                                [],
                            onSelected: (List<Category> items) {
                              setState(() {
                                _createProfileRequest =
                                    _createProfileRequest.copyWith(
                                        selectedCoachingCategories: items);
                              });
                            },
                          ),
                        if (isConsultantTrainer) const SizedBox(height: 10),
                        if (isConsultantTrainer)
                          MultiSelectCategoriesField(
                            label: S.of(context).consultancyCategories,
                            categories: state.serviceCategories ?? [],
                            selectedItems: _createProfileRequest
                                    .selectedServiceCategories ??
                                [],
                            onSelected: (List<Category> items) {
                              setState(() {
                                _createProfileRequest = _createProfileRequest
                                    .copyWith(selectedServiceCategories: items);
                              });
                            },
                          ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context).serviceProvidedTo,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        ...kCountriesForService
                            .map(
                              (item) => SelectItem(
                                  item: item,
                                  isSelected: _createProfileRequest
                                          .serviceProvidedTo
                                          ?.firstWhereOrNull(
                                              (e) => e == item['code']) !=
                                      null,
                                  onTap: _onSelectServiceProvidedTo),
                            )
                            .toList(),
                        const SizedBox(height: 15),
                        Text(S.of(context).websiteSocialMedia,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 15),
                        BasicTextField(
                          hintText: "https://www.tiktok.com/@tiktok_id",
                          controller: _tiktokController,
                          label: 'Tiktok',
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          hintText: "https://www.facebook.com/@fb_id",
                          controller: _fbController,
                          label: 'Facebook',
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          hintText: "https://twitter.com/twitter_id",
                          controller: _twitterController,
                          label: 'Twitter',
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          hintText: "https://www.instagram.com/ins_id",
                          controller: _instagramController,
                          label: 'Instagram',
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          hintText: "https://www.youtube.com/@youtube_id",
                          controller: _youtubeController,
                          label: 'Youtube',
                        ),
                        const SizedBox(height: 10),
                        BasicTextField(
                          hintText: "https://missindependentme.com",
                          controller: _websiteController,
                          label: 'Website',
                        ),
                        const SizedBox(height: 10),
                        CheckBoxItem(
                          label: Text.rich(
                            TextSpan(
                                text: S.of(context).iAgreeTo,
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: " ${S.of(context).termsOfServices}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _openTerms,
                                  )
                                ]),
                          ),
                          value: _readTerms,
                          onChanged: (bool value) {
                            setState(() {
                              _readTerms = value;
                            });
                          },
                        ),
                        CheckBoxItem(
                          label: Text(
                            S.of(context).makeMyInfoOnlyVisibleToAdmin,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: _createProfileRequest.visibleToAdmin ?? false,
                          onChanged: (bool value) {
                            setState(() {
                              _createProfileRequest = _createProfileRequest
                                  .copyWith(visibleToAdmin: value);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        BasicButton(
                            width: double.infinity,
                            onPressed: () {
                              _submitLogin(context);
                            },
                            label: S.of(context).signUp,
                            isLoading: state.createProfileStatus ==
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

  void _onSelectServiceProvidedTo(String value) {
    final bool isExisted = _createProfileRequest.serviceProvidedTo
            ?.firstWhereOrNull((e) => e == value) !=
        null;
    if (isExisted) {
      if (value == 'worldwide') {
        setState(() {
          _createProfileRequest =
              _createProfileRequest.copyWith(serviceProvidedTo: []);
        });
      } else {
        setState(() {
          _createProfileRequest = _createProfileRequest.copyWith(
              serviceProvidedTo: _createProfileRequest.serviceProvidedTo
                  ?.where((e) => e != value && e != 'worldwide')
                  .toList());
        });
      }
    } else {
      if (value == 'worldwide') {
        setState(() {
          _createProfileRequest = _createProfileRequest.copyWith(
              serviceProvidedTo:
                  kCountriesForService.map((e) => e['code'] ?? '').toList());
        });
      } else {
        setState(() {
          List<String> newItems = [
            ...?_createProfileRequest.serviceProvidedTo,
            value
          ];
          bool all = newItems.length == kCountriesForService.length - 1;
          _createProfileRequest = _createProfileRequest.copyWith(
              serviceProvidedTo: all
                  ? kCountriesForService.map((e) => e['code'] ?? '').toList()
                  : newItems);
        });
      }
    }
  }

  Future _openTerms() async {
    Navigator.pushNamed(context, kWebViewRoute,
        arguments: WebViewArg(
            url: BuildConfig.kTermsOfConditions,
            title: S.of(context).termsOfServices));
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _createProfileRequest = _createProfileRequest.copyWith(
          name: _nameController.text,
          businessName: _businessNameController.text,
          businessEmail: _businessEmailController.text,
          aboutMe: _aboutMeController.text,
          tiktok: _tiktokController.text,
          facebook: _fbController.text,
          twitter: _twitterController.text,
          instagram: _instagramController.text,
          youtube: _youtubeController.text,
          website: _websiteController.text);
      context.read<AuthCubit>().createProfile(_createProfileRequest);
    }
  }
}
