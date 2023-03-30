import 'package:flutter/material.dart';

import '../../common/theme/colors.dart';
import 'expandable.dart';

class ExpandableContent extends StatelessWidget {
  const ExpandableContent(
      {Key? key,
      required this.title,
      required this.child,
      this.onRemoved,
      this.borderRadius = 4.0,
      this.backgroundColor = Colors.white,
      this.headerColor,
      this.headerTextStyle,
      this.initialExpanded = true})
      : super(key: key);
  final String title;
  final Widget child;
  final VoidCallback? onRemoved;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? headerColor;
  final TextStyle? headerTextStyle;
  final bool initialExpanded;

  @override
  Widget build(BuildContext context) {
    if (borderRadius != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          border: Border.all(color: const Color(0xFFd9edf7)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius!),
          child: _renderContent(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFd9edf7)),
        ),
        child: _renderContent(),
      );
    }
  }

  Widget _renderContent() {
    return ExpandablePanel(
      headerColor: headerColor ?? const Color(0xFFd9edf7),
      initialExpanded: initialExpanded,
      theme: const ExpandableThemeData(
        iconColor: Color(0xFF73EFB6),
        useInkWell: true,
        inkWellBorderRadius: BorderRadius.zero,
        animationDuration: Duration(milliseconds: 300),
        scrollAnimationDuration: Duration(milliseconds: 300),
        crossFadePoint: 0.5,
        fadeCurve: Curves.linear,
        sizeCurve: Curves.fastOutSlowIn,
        alignment: Alignment.topLeft,
        headerAlignment: ExpandablePanelHeaderAlignment.top,
        bodyAlignment: ExpandablePanelBodyAlignment.left,
        iconPlacement: ExpandablePanelIconPlacement.right,
        tapHeaderToExpand: true,
        tapBodyToExpand: false,
        tapBodyToCollapse: false,
        hasIcon: true,
        iconSize: 20.0,
        iconPadding: EdgeInsets.all(8.0),
        expandIcon: Icons.expand_more,
        collapseIcon: Icons.expand_more,
      ),
      header: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: headerTextStyle)),
            if (onRemoved != null)
              IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: onRemoved,
                  icon: const Icon(Icons.delete),
                  color: const Color(0xFF73EFB6))
          ],
        ),
      ),
      collapsed: const SizedBox(),
      expanded: Container(color: backgroundColor, child: child),
    );
  }
}

class ExpandableMenuContent extends StatelessWidget {
  const ExpandableMenuContent(
      {Key? key,
      this.icon,
      required this.title,
      required this.child,
      this.borderRadius,
      this.backgroundColor,
      this.headerColor})
      : super(key: key);
  final Widget? icon;
  final String title;
  final Widget child;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? headerColor;

  @override
  Widget build(BuildContext context) {
    return _renderContent();
  }

  Widget _renderContent() {
    return ExpandablePanel(
      headerColor: headerColor,
      initialExpanded: false,
      theme: const ExpandableThemeData(
        iconColor: kGreyColor,
        useInkWell: true,
        inkWellBorderRadius: BorderRadius.zero,
        animationDuration: Duration(milliseconds: 300),
        scrollAnimationDuration: Duration(milliseconds: 300),
        crossFadePoint: 0.5,
        fadeCurve: Curves.linear,
        sizeCurve: Curves.fastOutSlowIn,
        alignment: Alignment.topLeft,
        headerAlignment: ExpandablePanelHeaderAlignment.top,
        bodyAlignment: ExpandablePanelBodyAlignment.left,
        iconPlacement: ExpandablePanelIconPlacement.right,
        tapHeaderToExpand: true,
        tapBodyToExpand: false,
        tapBodyToCollapse: false,
        hasIcon: true,
        iconSize: 20.0,
        iconPadding: EdgeInsets.all(8.0),
        expandIcon: Icons.expand_more,
        collapseIcon: Icons.expand_more,
      ),
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            if (icon != null) icon!,
            const SizedBox(width: 10),
            Expanded(
                child: Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.white))),
          ],
        ),
      ),
      collapsed: const SizedBox(),
      expanded: Container(color: backgroundColor, child: child),
    );
  }
}
