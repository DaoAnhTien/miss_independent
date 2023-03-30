import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

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
    return GestureDetector(
      onTap: () async {
        _pickImages(context);
      },
      child: const Icon(
        CupertinoIcons.photo,
        color: kPrimaryColor,
        size: 64,
      ),
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
