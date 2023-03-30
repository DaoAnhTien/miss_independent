import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/widgets/button.dart';
import '../../../common/utils/toast.dart';
import '../../../widgets/text_field.dart';

class UploadMedias extends StatefulWidget {
  const UploadMedias(
      {Key? key,
      this.file,
      required this.onChanged,
      this.enabled = true,
      required this.linkVideoController,
      this.isShowChoosesVideo = false,
      required this.onSelectMediaType})
      : super(key: key);
  final String? file;
  final TextEditingController linkVideoController;
  final Function(List<XFile>?) onChanged;
  final bool enabled;
  final bool isShowChoosesVideo;
  final Function(bool) onSelectMediaType;

  @override
  State<UploadMedias> createState() => _UploadMedias();
}

class _UploadMedias extends State<UploadMedias> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                widget.onSelectMediaType(false);
                _pickImages(context);
              },
              child: const Icon(
                CupertinoIcons.photo,
                color: kPrimaryColor,
                size: 64,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => widget.onSelectMediaType(true),
              child: const Icon(
                CupertinoIcons.film,
                color: kPrimaryColor,
                size: 64,
              ),
            ),
          ],
        ),
        if (widget.isShowChoosesVideo)
          Column(
            children: [
              const SizedBox(height: 24),
              BasicButton(
                label: S.of(context).selectAVideo,
                backgroundColor: Colors.grey.shade800,
                onPressed: () => _pickVideo(context),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).or,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BasicTextField(
                controller: widget.linkVideoController,
                hintText: S.of(context).pasteVideoLinkHere,
                multiline: false,
              ),
            ],
          )
      ],
    );
  }

  Future _pickImages(BuildContext context) async {
    try {
      final List<XFile> image = await _picker.pickMultiImage();
      widget.onChanged(image);
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }

  Future _pickVideo(BuildContext context) async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        widget.onChanged([video]);
      }
    } catch (e) {
      showErrorMessage(context, e.toString());
    }
  }
}
