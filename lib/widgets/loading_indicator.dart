import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.color, this.size}) : super(key: key);
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: color ?? Theme.of(context).primaryColor,
      size: size ?? 30.0,
    );
  }
}
