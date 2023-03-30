import 'package:flutter/material.dart';

import '../models/pagination.dart';
import 'list_bundle.dart';

class ListContentGridView extends StatelessWidget {
  const ListContentGridView({
    super.key,
    required this.padding,
    required this.countItems,
    required this.widthItem,
    required this.heightItem,
    required this.children,
    this.status,
    required this.onRefresh,
    this.onLoadMore,
    this.errMsg,
  });

  final double padding;
  final int countItems;
  final double widthItem;
  final double heightItem;

  final List<Widget> children;
  final DataSourceStatus? status;
  final VoidCallback onRefresh;
  final String? errMsg;
  final VoidCallback? onLoadMore;
  @override
  Widget build(BuildContext context) {
    return ListBundle(
        status: status,
        errMsg: errMsg,
        onRefresh: (BuildContext context) async {
          onRefresh();
        },
        onLoadMore: (BuildContext context) async {
          onLoadMore?.call();
        },
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.count(
              crossAxisCount: countItems,
              childAspectRatio: widthItem / heightItem,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
              children: children),
        ));
  }
}

