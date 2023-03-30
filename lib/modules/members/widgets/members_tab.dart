
import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';

enum MembersTab { latest, online, membership }

extension MembersTabX on MembersTab {
  String get displayName {
    switch (this) {
      case MembersTab.latest:
        return S.current.latest;
      case MembersTab.online:
        return S.current.online;
      case MembersTab.membership:
        return S.current.membership;
    }
  }
  String get rawValue {
    switch (this) {
      case MembersTab.latest:
        return 'latest';
      case MembersTab.online:
        return 'online';
      case MembersTab.membership:
        return 'membership';
    }
  }
}

class MembersTabs extends StatelessWidget {
  const MembersTabs({Key? key, required this.selected, required this.onChanged})
      : super(key: key);
  final MembersTab selected;
  final Function(MembersTab) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kLightGreyColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ...MembersTab.values.map((e) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    onChanged(e);
                  },
                  child: Container(
                    color: selected.rawValue == e.rawValue
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    height: 44,
                    child: Center(
                      child: Text(
                        e.displayName,
                        style: selected.rawValue == e.rawValue
                            ? Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.white)
                            : Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
