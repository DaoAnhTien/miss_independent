import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miss_independent/models/asset.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_videos_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_videos_state.dart';
import 'package:miss_independent/modules/user_detail/widgets/thumbnail_item.dart';
import 'package:miss_independent/modules/user_detail/widgets/user_profile_tabs.dart';
import 'package:miss_independent/modules/user_detail/widgets/video_view.dart';

import '../../../common/theme/colors.dart';
import '../../../models/pagination.dart';

class UserVideos extends StatefulWidget {
  const UserVideos({super.key});
  @override
  State<UserVideos> createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double padding = 4;
    int countItems = 3;
    double widthItem = (widthScreen - (countItems + 1) * padding) / countItems;
    double heightItem = widthItem * 4 / 3;
    return BlocBuilder<UserVideosCubit, UserVideosState>(
      builder: (context, state) {
        if ([
          DataSourceStatus.initial,
          DataSourceStatus.refreshing,
          DataSourceStatus.loading
        ].contains(state.status)) {
          return SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 200,
                child: Center(
                  child: SpinKitWave(
                    color: kPrimaryColor,
                    size: 20.0,
                  ),
                ),
              ),
            ]),
          );
        }

        List<Asset> assets = [];
        state.videos?.forEach((element) {
          assets = [...assets, ...?element.assets];
        });
        return SliverGrid.count(
            crossAxisCount: countItems,
            childAspectRatio: widthItem / heightItem,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
            children: List.generate(assets.length, (index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoItemView(url: assets[index].link),
                    )),
                child: ThumbnailItem(
                  heightItem: heightItem,
                  widthItem: widthItem,
                  thumbnailLink: assets[index].thumbnailLink,
                  userDetailTab: UserProfileTab.videos,
                ),
              );
            }));
      },
    );
  }
}
