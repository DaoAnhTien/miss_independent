import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miss_independent/modules/home/widgets/post_item.dart';

import '../../../common/theme/colors.dart';
import '../../../models/pagination.dart';
import '../bloc/user_editorials_cubit.dart';
import '../bloc/user_editorials_state.dart';

class UserEditorials extends StatelessWidget {
  const UserEditorials({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserEditorialsCubit, UserEditorialsState>(
      builder: (context, UserEditorialsState state) {
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

        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return state.editorials == null
              ? const SizedBox()
              : PostItem(
                  onLikePost: () => context
                      .read<UserEditorialsCubit>()
                      .likePost(state.editorials![index].id ?? 0),
                  post: state.editorials![index],
                );
        }, childCount: state.editorials?.length ?? 0));
      },
    );
  }
}
