import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'common/constants.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer(
      {Key? key, required this.small, this.medium, required this.large})
      : super(key: key);
  final Widget small;
  final Widget? medium;
  final Widget large;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, SizingInformation sizingInformation) {
      if (sizingInformation.screenSize.width < kSmallScreenSize) {
        return small;
      } else if (sizingInformation.screenSize.width < kMediumScreenSize) {
        return medium ?? small;
      } else {
        return large;
      }
    });
  }
}
