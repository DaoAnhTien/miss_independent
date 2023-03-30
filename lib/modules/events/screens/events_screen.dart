import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/event.dart';
import 'package:miss_independent/modules/events/bloc/events_cubit.dart';
import 'package:miss_independent/modules/events/bloc/events_state.dart';
import 'package:miss_independent/modules/events/widgets/event_item.dart';
import 'package:miss_independent/widgets/list_content.dart';

import '../../../widgets/button.dart';
import '../../../widgets/expandable_content/index.dart';
import '../../../widgets/text_field.dart';

import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tileController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<EventsCubit>(
      create: (_) => getIt<EventsCubit>()..fetchItems("", ""),
      child: BlocBuilder<EventsCubit, EventsState>(
          builder: (BuildContext context, EventsState state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableContent(
                  initialExpanded: false,
                  title: S.of(context).searchEvents,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        BasicTextField(
                          controller: tileController,
                          label: S.of(context).title,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SelectDateTextField(
                          label: S.of(context).date,
                          value: datePickerController.text.isNotEmpty
                              ? DateFormat("yyyy-MM-dd")
                                  .parse(datePickerController.text)
                              : DateTime.now(),
                          onChanged: _onChangeDate,
                          controller: datePickerController,
                        ),
                        const SizedBox(height: 10),
                        BasicButton(
                          width: double.infinity,
                          onPressed: () {
                            _onSearch(context);
                          },
                          label: S.of(context).search,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: ListContent<Event>(
                        status: state.status,
                        list: state.events,
                        onRefresh: () {},
                        itemBuilder: (Event item) {
                          return EventItem(event: item);
                        }))
              ],
            ),
          ),
        );
      }),
    ));
  }

  void _onChangeDate(DateTime? dateTime) {
    datePickerController.text = dateTime?.toYYYYMMDDString() ?? '';
  }

  void _onSearch(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EventsCubit>().fetchItems(
            tileController.text,
            datePickerController.text,
          );
    }
  }
}
