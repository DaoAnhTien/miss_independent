import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
import 'package:miss_independent/models/event.dart';

import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../widgets/cached_image.dart';
import '../bloc/event_detail_cubit.dart';
import '../bloc/event_detail_state.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Event? event = context.getRouteArguments<Event>();
    double avatarHeight = 220;
    double widthScreen = MediaQuery.of(context).size.width;
    return BlocProvider<EventDetailCubit>(
        create: (_) => getIt<EventDetailCubit>()
          ..init(event)
          ..fetchEvent(event?.id ?? 0, event?.userId ?? 0),
        child: BlocConsumer<EventDetailCubit, EventDetailState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == RequestStatus.failed &&
                  (state.message?.isNotEmpty ?? false)) {
                showErrorMessage(context, state.message!);
              }
            },
            builder: (BuildContext context, EventDetailState state) => Scaffold(
                appBar: AppBar(
                  title: Text(state.event?.title ?? ""),
                  actions: [
                    IconButton(
                        onPressed: () {
                          _onFavorite(
                              context,
                              state.event?.id ?? 0,
                              state.event?.userId ?? 0,
                              state.event?.favBit ?? false);
                        },
                        icon: Icon(
                          state.event?.favBit == true
                              ? CupertinoIcons.hand_thumbsup_fill
                              : CupertinoIcons.hand_thumbsup,
                          color: kWhiteColor,
                        )),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: Colors.grey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedImage(
                                fit: BoxFit.cover,
                                url: state.event?.image,
                                width: widthScreen,
                                height: avatarHeight,
                              ),
                              if (state.event?.fromDate != null &&
                                  state.event?.toDate != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Text(
                                    "${state.event!.fromDate!.eventTimeFormat()} to  ${state.event!.toDate!.eventTimeFormat()}",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                )
                            ],
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.location_solid,
                                    size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  state.event?.location ?? "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Html(
                              data: state.event?.description,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }

  void _onFavorite(
      BuildContext context, int eventId, int userId, bool isFavovited) {
    if (isFavovited == true) {
      context.read<EventDetailCubit>().eventUnFav(eventId, userId);
    } else {
      context.read<EventDetailCubit>().eventFav(eventId, userId);
    }
  }
}
