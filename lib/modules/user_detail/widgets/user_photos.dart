import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miss_independent/models/asset.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_photos_cubit.dart';
import 'package:miss_independent/modules/user_detail/bloc/user_photos_state.dart';
import 'package:miss_independent/modules/user_detail/widgets/photo_view.dart';
import 'package:miss_independent/modules/user_detail/widgets/thumbnail_item.dart';
import 'package:miss_independent/modules/user_detail/widgets/user_profile_tabs.dart';

import '../../../common/theme/colors.dart';
import '../../../models/pagination.dart';

class UserPhotos extends StatefulWidget {
  const UserPhotos({super.key});
  @override
  State<UserPhotos> createState() => _UserPhotosState();
}

class _UserPhotosState extends State<UserPhotos> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double padding = 4;
    int countItems = 3;
    double widthItem = (widthScreen - (countItems + 1) * padding) / countItems;
    double heightItem = widthItem * 4 / 3;
    return BlocBuilder<UserPhotosCubit, UserPhotosState>(
      builder: (context, state) {
        List<Asset> assets = [];
        state.photos?.forEach((element) {
          assets = [...assets, ...?element.assets];
        });
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
        return SliverGrid.count(
            crossAxisCount: countItems,
            childAspectRatio: widthItem / heightItem,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
            children: List.generate(assets.length, (index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhotoItemView(
                      assets: assets,
                      index: index,
                    ),
                  ),
                ),
                child: ThumbnailItem(
                  heightItem: heightItem,
                  widthItem: widthItem,
                  thumbnailLink: assets[index].link,
                  userDetailTab: UserProfileTab.photos,
                ),
              );
            }));
      },
    );
  }
}
