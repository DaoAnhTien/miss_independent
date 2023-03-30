import 'package:flutter/material.dart';
import 'package:miss_independent/common/theme/colors.dart';
import "package:miss_independent/generated/l10n.dart";

enum MiForumDetailTab { home, members, forum }

extension MiForumTabX on MiForumDetailTab {
  String get displayName {
    switch (this) {
      case MiForumDetailTab.forum:
        return S.current.forum;
      case MiForumDetailTab.members:
        return S.current.members;
      case MiForumDetailTab.home:
        return S.current.home;
    }
  }
}

class MiForumDetailTabs extends StatelessWidget {
  const MiForumDetailTabs(
      {Key? key, required this.selected, required this.onChanged})
      : super(key: key);
  final MiForumDetailTab selected;
  final Function(MiForumDetailTab) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kLightGreyColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ...MiForumDetailTab.values.map((e) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    onChanged(e);
                  },
                  child: Container(
                    color: selected == e
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    height: 56,
                    child: Center(
                      child: Text(
                        e.displayName,
                        style: selected == e
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
