import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/common/utils/extensions/string_extension.dart';
import 'package:transparent_image/transparent_image.dart';

import '../common/constants/images.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      {Key? key,
      this.url,
      this.width,
      this.height,
      this.fit,
      this.radius,
      this.color})
      : super(key: key);
  final String? url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (url?.isNotEmpty ?? false) ? url! : kDefaultImage;
    final bool isSvg = imageUrl.contains('.svg');

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0.0),
      child: (imageUrl.indexOf('assets') == 0 || !imageUrl.contains('http'))
          ? isSvg
              ? imageUrl.toSvg(
                  width: width, height: height, context: context, color: color)
              : Image.asset(imageUrl,
                  width: width, height: height, fit: fit, color: color)
          : kIsWeb
              ? FadeInImage.memoryNetwork(
                  width: width,
                  height: height,
                  fit: fit,
                  image: url ?? kDefaultImage,
                  placeholder: kTransparentImage,
                )
              : CachedNetworkImage(
                  width: width,
                  height: height,
                  fit: fit,
                  // placeholder: (context, url) => SizedBox(
                  //   width: width ?? 60.0,
                  //   height: width ?? 60.0,
                  //   child: Center(
                  //     child: SpinKitWave(
                  //       color: kPrimaryColor.withOpacity(0.5),
                  //       size: (width ?? 60.0) * 0.4,
                  //     ),
                  //   ),
                  // ),
                  imageUrl: url ?? kDefaultImage,
                  color: color),
    );
  }
}
