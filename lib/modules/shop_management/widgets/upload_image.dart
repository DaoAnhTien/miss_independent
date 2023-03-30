import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/generated/l10n.dart';

import '../../../common/theme/colors.dart';
import '../../../common/utils/toast.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key, required this.onChanged});
  final Function(XFile?) onChanged;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            _pickImages(context);
          },
          child: Container(
            height: 130,
            width: 130,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: kGreyColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.cloud_upload,
                    color: kPrimaryColor,
                    size: 64,
                  ),
                  Text(
                    S.of(context).upload,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _pickImages(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      widget.onChanged(image);
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }
}
