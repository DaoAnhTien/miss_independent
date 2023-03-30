import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/widgets/cached_image.dart';

import '../common/constants/images.dart';
import '../common/utils/toast.dart';

class UploadImageProfile extends StatefulWidget {
  const UploadImageProfile(
      {Key? key,
      this.file,
      required this.onChanged,
      this.enabled = true,
      this.isShowImageFile = false,
      this.xFile})
      : super(key: key);
  final String? file;
  final XFile? xFile;
  final Function(XFile?) onChanged;
  final bool enabled;
  final bool isShowImageFile;

  @override
  State<UploadImageProfile> createState() => _UploadImageProfileState();
}

class _UploadImageProfileState extends State<UploadImageProfile> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.enabled ? _pickImage(context) : null,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: widget.isShowImageFile
                    ? Image.file(
                        File(widget.xFile?.path ?? ""),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                    : CachedImage(
                        url: widget.file ?? kDefaultImage,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )),
            Positioned(
              right: 5,
              top: 5,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _pickImage(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      widget.onChanged(image);
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }
}
