import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/services/widgets/select_category_field.dart';
import 'package:miss_independent/widgets/button.dart';
import 'package:miss_independent/widgets/list_content.dart';
import 'package:miss_independent/widgets/text_field.dart';

import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../generated/l10n.dart';
import '../../../models/category.dart';
import '../../../widgets/expandable_content/index.dart';
import '../bloc/mi_services_cubit.dart';
import '../bloc/mi_services_state.dart';
import '../widgets/user_service_item.dart';

class MIServicesScreen extends StatefulWidget {
  const MIServicesScreen({Key? key, required this.type}) : super(key: key);
  final ServiceProviderType type;

  @override
  State<MIServicesScreen> createState() => _MIServicesScreenState();
}

class _MIServicesScreenState extends State<MIServicesScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MIServicesCubit>()
        ..initWithType(widget.type)
        ..getCategories()
        ..refreshItems(isInit: true),
      child: BlocConsumer<MIServicesCubit, MIServicesState>(
          listenWhen: (MIServicesState prev, MIServicesState current) =>
              prev.status != current.status,
          listener: (context, MIServicesState state) {
            if (state.status == DataSourceStatus.failed &&
                (state.message?.isNotEmpty ?? false)) {
              showErrorMessage(context, state.message!);
            }
          },
          builder: (context, MIServicesState state) {
            return Scaffold(
              appBar: AppBar(
                  title: Text(widget.type == ServiceProviderType.coachMentor
                      ? S.of(context).coachesAndMentors
                      : S.of(context).consultantTrainer)),
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      ExpandableContent(
                        initialExpanded: false,
                        title: widget.type == ServiceProviderType.coachMentor
                            ? S.of(context).findYourIdealCoachesMentors
                            : S.of(context).findYourIdealConsultantsTrainers,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SelectCategoryField(
                                  categories: state.categories ?? [],
                                  controller: _categoryController,
                                  onSelected: (Category category) {
                                    _categoryController.text =
                                        category.name ?? "";
                                  }),
                              const SizedBox(height: 5.0),
                              BasicTextField(
                                  controller: _nameController,
                                  hintText: S.of(context).searchName),
                              const SizedBox(height: 5.0),
                              BasicTextField(
                                  controller: _locationController,
                                  hintText: S.of(context).location),
                              const SizedBox(height: 5.0),
                              BasicButton(
                                  onPressed: () => _onSearch(
                                      context,
                                      _nameController.text,
                                      _locationController.text,
                                      _categoryController.text),
                                  label: S.of(context).search,
                                  width: double.infinity)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListContent<User>(
                          list: state.users,
                          status: state.status,
                          onRefresh: () => _onRefresh(context),
                          onLoadMore: () => _onLoadMore(context),
                          itemBuilder: (User item) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Navigator.of(context).pushNamed(
                                  widget.type == ServiceProviderType.coachMentor
                                      ? kCoachesMentorsDetailRoute
                                      : kConsultantsTrainersDetailRoute,
                                  arguments: item),
                              child: UserServiceItem(
                                item: item,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _onSearch(BuildContext context, String? text, String? location,
      String? categoryName) {
    context
        .read<MIServicesCubit>()
        .searchServices(text, location, categoryName);
  }

  void _onRefresh(BuildContext context) {
    context.read<MIServicesCubit>().refreshItems();
  }

  void _onLoadMore(BuildContext context) {
    context.read<MIServicesCubit>().loadMoreItems();
  }
}
