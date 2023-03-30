import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveFlowFlex extends StatelessWidget {
  const ResponsiveFlowFlex(
      {Key? key,
      required this.children,
      this.verticalSpacing = 20.0,
      this.horizontalSpacing = 15.0,
      this.minWidthItem = 300})
      : super(key: key);

  final List<Widget> children;
  final double verticalSpacing;
  final double horizontalSpacing;
  final double minWidthItem;

  Column _chunkItems(int size) {
    if (size == 1) {
      List<Widget> colItems = <Widget>[];
      for (int i = 0; i < children.length; i += 1) {
        colItems.add(children[i]);
        if (i < children.length - 1) {
          colItems.add(SizedBox(height: verticalSpacing));
        }
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: colItems);
    }

    final List<List<Widget>> chunked = <List<Widget>>[];
    for (int i = 0; i < children.length; i += size) {
      final int itemsSize = children.length - chunked.length * size;
      if (itemsSize > size) {
        chunked.add(children.slice(i, i + size));
      } else {
        chunked.add(children.slice(i, i + itemsSize));
      }
    }

    List<Widget> rows = <Widget>[];
    for (var e in chunked) {
      List<Widget> items = <Widget>[];
      for (int i = 0; i < size; i += 1) {
        if (e.length > i) {
          items.add(Expanded(child: e[i]));
        } else {
          items.add(const Expanded(child: SizedBox()));
        }
        if (i < size - 1) {
          items.add(SizedBox(width: horizontalSpacing));
        }
      }
      rows.add(
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: items));
    }

    List<Widget> colItems = <Widget>[];
    for (int i = 0; i < rows.length; i += 1) {
      colItems.add(rows[i]);
      if (i < rows.length - 1) {
        colItems.add(SizedBox(height: verticalSpacing));
      }
    }
    return Column(children: colItems);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, SizingInformation sizingInformation) {
      if (sizingInformation.screenSize.width <
          minWidthItem * 2 + horizontalSpacing) {
        return _chunkItems(1);
      } else if (sizingInformation.screenSize.width <
          minWidthItem * 3 + horizontalSpacing * 2) {
        return _chunkItems(2);
      } else {
        return _chunkItems(3);
      }
    });
  }
}
