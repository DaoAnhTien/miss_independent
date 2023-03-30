import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';

enum HomePostType { popular, latest, myPosts }

extension HomePostTypeX on HomePostType {
  String get displayName {
    switch (this) {
      case HomePostType.latest:
        return S.current.latest;
      case HomePostType.popular:
        return S.current.popular;
      case HomePostType.myPosts:
        return S.current.myPosts;
    }
  }

  String get rawValue {
    switch (this) {
      case HomePostType.latest:
        return 'all';
      case HomePostType.popular:
        return 'popular';
      case HomePostType.myPosts:
        return 'my';
    }
  }

  static HomePostType? initFrom(String? value) {
    return HomePostType.values.firstWhereOrNull(
        (HomePostType e) => e.rawValue.toLowerCase() == value?.toLowerCase());
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({Key? key, required this.selected, required this.onChanged})
      : super(key: key);
  final HomePostType selected;
  final Function(HomePostType) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kLightGreyColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ...HomePostType.values.map((e) => Expanded(
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
