
import 'package:flutter/material.dart';
import 'package:miss_independent/common/event/event_bus_event.dart';

import '../../../generated/l10n.dart';

class ExceptionErrorScreen extends StatelessWidget {
  final ApiExceptionEvent event;

  const ExceptionErrorScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).error),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "URL: ${event.baseUrl}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Method: ${event.method}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (event.method != 'GET') const SizedBox(height: 10),
                if (event.method != 'GET')
                  Text(
                    "Body: ${event.body}",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                const SizedBox(height: 30),
                Text(
                  event.errorMsg,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
