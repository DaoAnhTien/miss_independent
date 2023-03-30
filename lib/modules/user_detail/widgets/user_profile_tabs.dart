import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';

enum UserProfileTab { about, photos, videos, editorials }

extension UserProfileTabX on UserProfileTab {
  String get displayName {
    switch (this) {
      case UserProfileTab.about:
        return S.current.about;
      case UserProfileTab.photos:
        return S.current.photos;
      case UserProfileTab.videos:
        return S.current.videos;
      case UserProfileTab.editorials:
        return S.current.editorials;
    }
  }
}

class UserProfileTabs extends StatelessWidget {
  const UserProfileTabs(
      {Key? key, required this.selected, required this.onChanged})
      : super(key: key);
  final UserProfileTab selected;
  final Function(UserProfileTab) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kLightGreyColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ...UserProfileTab.values.map((e) => Expanded(
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
