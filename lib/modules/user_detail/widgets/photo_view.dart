import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/models/asset.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoItemView extends StatefulWidget {
  const PhotoItemView({super.key, required this.assets, this.index = 0});
  final List<Asset?> assets;
  final int index;

  @override
  State<PhotoItemView> createState() => _PhotoItemViewState();
}

class _PhotoItemViewState extends State<PhotoItemView> {
  late PageController pageController = PageController(
    initialPage: widget.index,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            widget.assets.length > 1
                ? PhotoViewGallery.builder(
                    pageController: pageController,
                    itemCount: widget.assets.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: CachedNetworkImageProvider(
                            widget.assets[index]?.link ?? ""),
                      );
                    },
                  )
                : PhotoView(
                    imageProvider: CachedNetworkImageProvider(
                        widget.assets[0]?.link ?? ""),
                  ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
