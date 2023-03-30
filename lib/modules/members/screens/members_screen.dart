import 'package:flutter/material.dart';
import 'package:miss_independent/modules/members/widgets/member_latest.dart';
import 'package:miss_independent/modules/members/widgets/member_online.dart';
import 'package:miss_independent/modules/members/widgets/member_ship.dart';
import 'package:miss_independent/modules/members/widgets/members_tab.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  MembersTab _selectedType = MembersTab.latest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: MembersTabs(
                selected: _selectedType,
                onChanged: (MembersTab type) {
                  _onChangedTab(context, type);
                }),
          ),
          if (_selectedType == MembersTab.membership) const MembersShip(),
          if (_selectedType == MembersTab.latest) const MembersLatest(),
          if (_selectedType == MembersTab.online) const MembersOnline()
        ],
      ),
    );
  }

  void _onChangedTab(BuildContext context, MembersTab type) {
    setState(() {
      _selectedType = type;
    });
  }
}
