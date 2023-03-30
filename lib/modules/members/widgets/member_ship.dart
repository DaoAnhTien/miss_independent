import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../../../models/user.dart';
import '../../../widgets/list_content.dart';
import '../../../widgets/text_field.dart';
import '../bloc/member_cubit.dart';
import '../bloc/member_state.dart';
import 'member_item.dart';

class MembersShip extends StatefulWidget {
  const MembersShip({Key? key}) : super(key: key);

  @override
  State<MembersShip> createState() => _MembersShipState();
}

class _MembersShipState extends State<MembersShip> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberCubit>(
        create: (_) => getIt<MemberCubit>()
          ..changeMemberShipType(MembershipType.tulip.rawValue),
        child: BlocBuilder<MemberCubit, MemberState>(
            builder: (BuildContext context, MemberState state) {
          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SelectTextField(
                        value: state.membershipType,
                        // label: S.of(context).membershipType,
                        onChanged: (String? value) {
                          context
                              .read<MemberCubit>()
                              .changeMemberShipType(value);
                        },
                        items: MembershipType.values
                            .map((e) => SelectTextFieldArg(
                                label: e.displayName, value: e.rawValue))
                            .toList(),
                      ),
                      if (state.membershipType ==
                          MembershipType.serviceProvider.rawValue)
                        const SizedBox(height: 10),
                      if (state.membershipType ==
                          MembershipType.serviceProvider.rawValue)
                        SelectTextField(
                          value: state.serviceProviderType,
                          onChanged: (String? value) {
                            setState(() {
                              context
                                  .read<MemberCubit>()
                                  .changeServiceProviderType(value);
                            });
                          },
                          items: ServiceProviderType.values
                              .map((e) => SelectTextFieldArg(
                                  label: e.displayName, value: e.rawValue))
                              .toList(),
                        ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListContent<User>(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 12, right: 16),
                  list: state.members,
                  status: state.status,
                  onRefresh: () => _onRefresh(context),
                  onLoadMore: () => _onLoadMore(context),
                  itemBuilder: (User item) {
                    return MemberItem(
                      member: item,
                    );
                  },
                )),
              ],
            ),
          );
        }));
  }

  void _onRefresh(BuildContext context) {
    context.read<MemberCubit>().refreshItemsMembership();
  }

  void _onLoadMore(BuildContext context) {
    context.read<MemberCubit>().loadMoreItemsMembership();
  }
}
