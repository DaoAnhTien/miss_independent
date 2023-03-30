import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../generated/l10n.dart';

class BasicButton extends StatelessWidget {
  const BasicButton(
      {Key? key,
      this.onPressed,
      required this.label,
      this.isLoading,
      this.backgroundColor,
      this.textColor,
      this.width,
      this.height,
      this.border,
      this.padding,
      this.disabled = false,
      this.textStyle,
      this.icon, this.spinKitWaveColor = Colors.white})
      : super(key: key);
  final VoidCallback? onPressed;
  final String label;
  final bool? isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color spinKitWaveColor;
  final Widget? icon;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading == true || disabled ? null : onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: backgroundColor == Colors.transparent
                ? backgroundColor
                : (backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(disabled ? 0.6 : 1),
            border: border,
            borderRadius: BorderRadius.circular(4.0)),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && isLoading != true) icon!,
            if (icon != null && isLoading != true) const SizedBox(width: 6),
            if (isLoading == true)
               SpinKitWave(
                color: spinKitWaveColor,
                size: 20.0,
              ),
            if (isLoading == true) const SizedBox(width: 5.0),
            Text(isLoading == true ? S.of(context).loading : label,
                style: textStyle ??
                    Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: textColor ?? Colors.white))
          ],
        ),
      ),
    );
  }
}
