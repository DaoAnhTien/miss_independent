import 'package:flutter/material.dart';

import '../models/pagination.dart';
import 'list_bundle.dart';

class ListContent<T> extends StatelessWidget {
  const ListContent(
      {Key? key,
      this.list,
      this.status,
      required this.onRefresh,
      this.onLoadMore,
      required this.itemBuilder,
      this.controller,
      this.padding,
      this.errMsg,
      this.separatorWidget})
      : super(key: key);
  final List<T>? list;
  final DataSourceStatus? status;
  final VoidCallback onRefresh;
  final VoidCallback? onLoadMore;
  final Widget Function(T) itemBuilder;
  final ScrollController? controller;
  final String? errMsg;
  final EdgeInsetsGeometry? padding;
  final Widget? separatorWidget;

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
      child: ListView.separated(
          controller: controller,
          padding: padding,
          primary: false,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: list?.length ?? 0,
          separatorBuilder: (BuildContext context, int index) =>
              separatorWidget ?? const SizedBox(),
          itemBuilder: (BuildContext context, int index) {
            final T? item = list?[index];
            return item != null ? itemBuilder(item) : const SizedBox();
          }),
    );
  }
}
