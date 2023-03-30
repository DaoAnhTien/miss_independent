import 'package:flutter/material.dart';
import 'package:miss_independent/generated/l10n.dart';

import '../../../common/constants/images.dart';
import '../../../widgets/button.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/text_field.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createEditorials),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const ClipOval(
                    child: CachedImage(
                        height: 60,
                        width: 60,
                        url: kDefaultImage,
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(S.of(context).notifications,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                )),
            BasicTextField(
              mandatory: true,
              // controller: _aboutMeController,
              label: S.of(context).aboutMe,
              multiline: true,
              // validator: CreateProfileValidator.aboutMeValidation,
            ),
            const SizedBox(
              height: 10,
            ),
            // UploadMedias(
            //   // file: _createProfileRequest.image?.path,
            //   onChanged: (XFile? file) {
            //     setState(() {
            //       // _createProfileRequest = _createProfileRequest
            //       //     .copyWith(image: file);
            //     });
            //   },
            // ),
            const SizedBox(
              height: 10,
            ),
            BasicTextField(
              mandatory: true,
              // controller: _aboutMeController,
              label: S.of(context).aboutMe,
              multiline: true,
              // validator: CreateProfileValidator.aboutMeValidation,
            ),
            const SizedBox(
              height: 10,
            ),
            BasicButton(
              width: double.infinity,
              onPressed: () {
                // _submitLogin(context);
              },
              label: S.of(context).editorials,
              // isLoading: state.loginStatus ==
              //     RequestStatus.requesting),
            ),
          ],
        ),
      ),
    );
  }
}
