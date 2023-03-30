import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/friend.dart';
import 'package:miss_independent/modules/friends/bloc/friends_cubit.dart';
import 'package:miss_independent/modules/friends/bloc/friends_state.dart';
import 'package:miss_independent/modules/friends/widgets/friend_item.dart';

import '../../../widgets/list_content.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<FriendsCubit>().refreshItems(isInit: true);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(S.of(context).friends),
      ),
      body: BlocBuilder<FriendsCubit, FriendsState>(
          builder: (BuildContext context, FriendsState state) {
        return ListContent<Friend>(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          list: state.friends,
          status: state.status,
          onRefresh: () => _onRefresh(context),
          onLoadMore: () => _onLoadMore(context),
          itemBuilder: (Friend item) {
            return FriendItem(friend: item);
          },
        );
      }),
    );
  }

  void _onRefresh(BuildContext context) {
    context.read<FriendsCubit>().refreshItems();
  }

  void _onLoadMore(BuildContext context) {
    context.read<FriendsCubit>().loadMoreItems();
  }
}
