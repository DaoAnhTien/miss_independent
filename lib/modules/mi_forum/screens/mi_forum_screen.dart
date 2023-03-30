import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_cubit.dart';
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_state.dart';
import 'package:miss_independent/modules/mi_forum/widgets/mi_forum_item.dart';

import '../../../common/theme/colors.dart';

class MiForumScreen extends StatefulWidget {
  const MiForumScreen({Key? key}) : super(key: key);

  @override
  State<MiForumScreen> createState() => _MiForumScreenState();
}

class _MiForumScreenState extends State<MiForumScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double padding = 6;
    int countItems = 2;
    double widthItem = (widthScreen - (countItems + 1) * padding) / countItems;
    double heightImg = widthItem;
    double heightText = 20.0;
    double heightItem = heightImg + heightText;
    return Scaffold(
      body: BlocProvider<MiForumCubit>(
        create: (_) => getIt<MiForumCubit>()..fetchItems(),
        child: BlocBuilder<MiForumCubit, MiForumState>(
            builder: (BuildContext context, MiForumState state) {
          if ([
            DataSourceStatus.initial,
            DataSourceStatus.refreshing,
            DataSourceStatus.loading
          ].contains(state.status)) {
            return const Center(
                child: SpinKitWave(
              color: kPrimaryColor,
              size: 20.0,
            ));
          }
          return Padding(
            padding: EdgeInsets.all(padding),
            child: GridView.count(
                crossAxisCount: countItems,
                childAspectRatio: widthItem / heightItem,
                crossAxisSpacing: padding,
                mainAxisSpacing: padding,
                children: List.generate(state.forums?.length ?? 0, (index) {
                  return MiForumItem(
                    forum: state.forums![index],
                    widthItem: widthItem,
                    heightText: heightText,
                  );
                })),
          );
        }),
      ),
    );
  }
}
