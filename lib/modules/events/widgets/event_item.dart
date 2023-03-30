// import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';
import 'package:miss_independent/models/event.dart';
import 'package:flutter/material.dart';
import '../../../common/theme/colors.dart';
import '../../../widgets/cached_image.dart';

class EventItem extends StatelessWidget {
  const EventItem({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(kEventDetailRoute, arguments: event);
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: kLightGreyColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CachedImage(
                  height: 66, width: 66, url: event.image, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    event.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(event.location ?? "",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 5),
                  Text(
                    "${event.fromDate?.eventTimeFormat()} to ${event.toDate?.eventTimeFormat()}",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
