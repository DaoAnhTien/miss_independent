import 'package:flutter/material.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/theme/colors.dart';

class BottomSheetReply extends StatelessWidget {
  const BottomSheetReply(
      {Key? key, this.onReply, required this.replyController})
      : super(key: key);
  final Function()? onReply;
  final TextEditingController replyController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: kWhiteColor),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            BasicTextField(
              controller: replyController,
              
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
