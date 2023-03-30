// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/notifications/bloc/notification_cubit.dart';
import 'package:miss_independent/modules/notifications/bloc/notification_state.dart';
import 'package:miss_independent/modules/notifications/widgets/notification_item.dart';

import '../../../models/notification.dart' as model;
import '../../../widgets/list_content.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifications),
      ),
      body: BlocProvider<NotificationCubit>(
        create: (_) => getIt<NotificationCubit>()..fetchItems(),
        child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (BuildContext context, NotificationState state) {
          return ListContent<model.Notification>(
            list: state.notifications,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            status: state.status,
            onRefresh: () => _onRefresh(context),
            itemBuilder: (model.Notification item) {
              return NotificationItem(
                notification: item,
              );
            },
          );
        }),
      ),
    );
  }

  void _onRefresh(BuildContext context) {
    context.read<NotificationCubit>().fetchItems();
  }
}
