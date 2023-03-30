import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:miss_independent/common/constants/images.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart';
import 'package:miss_independent/modules/user_detail/widgets/photo_view.dart';
import 'package:miss_independent/modules/user_detail/widgets/video_view.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:miss_independent/widgets/comments_list/comments_list.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_share/flutter_share.dart';
import '../../../models/asset.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import 'bottomsheet_post_actions.dart';

class PostItem extends StatelessWidget {
  const PostItem(
      {Key? key,
      required this.post,
      this.padding,
      this.onDelPost,
      this.onLikePost,
      this.onCommentsTap})
      : super(key: key);
  final Post post;
  final EdgeInsetsGeometry? padding;
  final Function()? onDelPost;
  final Function()? onLikePost;
  final VoidCallback? onCommentsTap;

  @override
  Widget build(BuildContext context) {
    MembershipType? membershipType =
        MembershipTypeX.initFrom(post.user?.role?.id?.toString());
    int? currentUserId = context.read<AuthCubit>().state.user?.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.user != null)
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(kUserProfileRouter, arguments: post.user),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CachedImage(
                                url: post.user?.image ?? kDefaultImage,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                radius: 25),
                            if (membershipType != null)
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: CachedImage(
                                          url: membershipType.icon,
                                          width: 18,
                                          height: 18),
                                    ),
                                  ))
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.user?.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                post.createdAt?.toTimeAgo() ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: kGreyColor),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (currentUserId != null) {
                                showModalBottomSheet<void>(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext ctx) {
                                    return BottomSheetPostActions(
                                      isMe: currentUserId == post.user?.id,
                                      onDelPost: onDelPost,
                                      post: post,
                                    );
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.more_horiz_outlined))
                      ],
                    ),
                  ),
                if (post.title?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(post.title!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700)),
                  ),
                if (post.text?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ReadMoreText(post.text!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  )
              ],
            ),
          ),
          if (post.type == PostType.image && (post.assets?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PostItemImage(assets: post.assets!),
            ),
          if (post.type == PostType.video && (post.assets?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PostItemVideo(assets: post.assets!),
            ),
          if (post.type == PostType.youtubeLink &&
              (post.assets?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PostItemVideo(assets: post.assets!),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onLikePost,
                  icon: CachedImage(
                    url: iconFly,
                    width: 20,
                    height: 20,
                    color: post.likedByLoggedInUser == true
                        ? kPrimaryColor
                        : kGreyColor,
                  ),
                  label: Text(
                    "${post.totalLikes ?? 0} ${S.of(context).flutters}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: post.likedByLoggedInUser == true
                            ? kPrimaryColor
                            : kGreyColor),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await FlutterShare.share(
                        title: post.title ?? 'Miss Independent',
                        text: post.text,
                        linkUrl: "https://app.mi.life/HomeScreen/${post.id}");
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                  ),
                  label: Text(
                    S.of(context).share,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: kGreyColor),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (onCommentsTap != null) {
                      onCommentsTap?.call();
                    } else {
                      Navigator.of(context).pushNamed(kPostCommentsRoute,
                          arguments:
                              CommentsListArgs.initPostComments(post.id ?? 0));
                    }
                  },
                  icon: const Icon(
                    Icons.comment,
                    size: 16,
                  ),
                  label: Text(
                    "${post.totalComments ?? 0} ${S.of(context).comments}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: kGreyColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 4, color: kLightGreyColor)
        ],
      ),
    );
  }
}

class PostItemImage extends StatelessWidget {
  const PostItemImage({Key? key, required this.assets}) : super(key: key);
  final List<Asset> assets;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<Size>(
        future: getImageSize(assets[0].link ?? ""),
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          } else {
            bool isVetical = snapshot.hasData
                ? (snapshot.data!.height >= snapshot.data!.width)
                : true;
            return SizedBox(
                height: size.width * (isVetical ? 1.2 : 0.85),
                width: size.width,
                child: assets.length > 1
                    ? Swiper(
                        layout: SwiperLayout.DEFAULT,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoItemView(
                                    assets: assets,
                                    index: index,
                                  ),
                                )),
                            child: CachedImage(
                              url: assets[index].link,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        autoplay: false,
                        itemCount: assets.length,
                        scrollDirection: Axis.horizontal,
                        pagination: const SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: SwiperPagination.dots),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PhotoItemView(assets: assets),
                            )),
                        child: CachedImage(
                          url: assets[0].link,
                          fit: BoxFit.cover,
                        ),
                      ));
          }
        });
  }
}

class PostItemVideo extends StatelessWidget {
  const PostItemVideo({Key? key, required this.assets}) : super(key: key);
  final List<Asset> assets;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<Size>(
        future: getImageSize(assets[0].thumbnailLink ?? ""),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          } else {
            bool isVetical = snapshot.hasData
                ? (snapshot.data!.height >= snapshot.data!.width)
                : true;
            return SizedBox(
              height: size.width * (isVetical ? 1.2 : 0.85),
              width: size.width,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoItemView(
                      url: assets[0].link,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CachedImage(
                        url: assets[0].thumbnailLink,
                        fit: BoxFit.cover,
                        width: size.width,
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill_outlined,
                        color: kWhiteColor,
                        size: 36,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}

Future<Size> getImageSize(String url) async {
  final imageProvider = CachedNetworkImageProvider(url);
  final completer = Completer<ImageInfo>();
  final stream = imageProvider.resolve(ImageConfiguration.empty);
  stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
  }));
  try {
    final image = await completer.future.timeout(const Duration(seconds: 10));
    return Size(image.image.width.toDouble(), image.image.height.toDouble());
  } on TimeoutException catch (_) {
    throw Exception('Timeout');
  } catch (e) {
    throw Exception('Error loading image: $e');
  }
}
