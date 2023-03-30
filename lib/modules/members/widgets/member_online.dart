import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../../../models/user.dart';
import '../../../widgets/list_content.dart';
import '../bloc/member_cubit.dart';
import '../bloc/member_state.dart';
import 'member_item.dart';

class MembersOnline extends StatefulWidget {
  const MembersOnline({Key? key}) : super(key: key);

  @override
  State<MembersOnline> createState() => _MembersOnlineState();
}

class _MembersOnlineState extends State<MembersOnline> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberCubit>(
        create: (_) => getIt<MemberCubit>()..refreshItemsOnline(),
        child: BlocBuilder<MemberCubit, MemberState>(
            builder: (BuildContext context, MemberState state) {
          return Expanded(
              child: ListContent<User>(
            padding: const EdgeInsets.only(left: 16, bottom: 12, right: 16),
            list: state.members,
            status: state.status,
            onRefresh: () => _onRefresh(context),
            onLoadMore: () => _onLoadMore(context),
            itemBuilder: (User item) {
              return MemberItem(
                member: item,
              );
            },
          ));
        }));
  }

  void _onRefresh(BuildContext context) {
    context.read<MemberCubit>().refreshItemsOnline();
  }

  void _onLoadMore(BuildContext context) {
    context.read<MemberCubit>().loadMoreItemsOnline();
  }
}
