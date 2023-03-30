import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/models/pagination.dart';

import '../../../common/theme/colors.dart';
import '../../../generated/l10n.dart';
import '../../../models/category.dart';
import '../../../widgets/list_bundle.dart';
import '../../../widgets/text_field.dart';

class MultiSelectCategoriesField extends StatefulWidget {
  const MultiSelectCategoriesField(
      {Key? key,
      this.label,
      required this.categories,
      this.controller,
      this.validator,
      this.enabled,
      required this.selectedItems,
      required this.onSelected,
      this.onClear})
      : super(key: key);
  final String? label;
  final List<Category> categories;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final List<Category> selectedItems;
  final Function(List<Category>) onSelected;
  final VoidCallback? onClear;

  @override
  State<MultiSelectCategoriesField> createState() =>
      _MultiSelectCategoriesFieldState();
}

class _MultiSelectCategoriesFieldState
    extends State<MultiSelectCategoriesField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty ?? false)
          Row(
            children: [
              Text(
                widget.label!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        if (widget.label?.isNotEmpty ?? false) const SizedBox(height: 10.0),
        GestureDetector(
          onTap: () => _showSearchItems(),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: kTextFieldHeight),
            decoration: BoxDecoration(
              border: Border.all(color: kLightGreyColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                spacing: 5,
                runSpacing: 5,
                children: [
                  ...widget.selectedItems
                      .map((e) => Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: kLightGreyColor,
                          label: Text(
                            e.name ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          deleteIcon: const Icon(Icons.close, size: 15),
                          onDeleted: () {
                            widget.onSelected(widget.selectedItems
                                .where((item) => item.id != e.id)
                                .toList());
                          }))
                      .toList()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showSearchItems() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Material(
                borderRadius: BorderRadius.circular(6.0),
                child: SelectItemPopup(
                  categories: widget.categories,
                  selectedItems: widget.selectedItems,
                  onSelected: widget.onSelected,
                )),
          ),
        );
      },
    );
  }
}

class SelectItemPopup extends StatefulWidget {
  const SelectItemPopup(
      {Key? key,
      required this.categories,
      required this.selectedItems,
      required this.onSelected})
      : super(key: key);
  final List<Category> categories;
  final List<Category> selectedItems;
  final Function(List<Category>) onSelected;

  @override
  State<SelectItemPopup> createState() => _SelectItemPopupState();
}

class _SelectItemPopupState extends State<SelectItemPopup> {
  late List<Category> _items = widget.categories;
  late List<Category> _selectedItems = widget.selectedItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).selectCategories,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, size: 20),
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: _onSearch,
          ),
          Expanded(
            child: ListBundle(
              status: DataSourceStatus.success,
              onRefresh: (BuildContext context) async {},
              onLoadMore: (BuildContext context) async {},
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Category item = _items[index];
                    return SearchItem(
                        item: item,
                        isSelected: _selectedItems
                                .firstWhereOrNull((e) => e.id == item.id) !=
                            null,
                        onTap: _onClickItem);
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).cancel,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              TextButton(
                onPressed: () {
                  widget.onSelected(_selectedItems);
                  Navigator.pop(context);
                },
                child: Text(S.of(context).ok),
              )
            ],
          )
        ],
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      _items = widget.categories
          .where((e) =>
              e.name?.toLowerCase().contains(value.toLowerCase()) ?? false)
          .toList();
    });
  }

  void _onClickItem(Category item) {
    final bool isExisted =
        _selectedItems.firstWhereOrNull((e) => e.id == item.id) != null;
    if (isExisted) {
      setState(() {
        _selectedItems = _selectedItems.where((e) => e.id != item.id).toList();
      });
    } else {
      setState(() {
        _selectedItems = [..._selectedItems, item];
      });
    }
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem(
      {Key? key,
      required this.item,
      required this.isSelected,
      required this.onTap})
      : super(key: key);
  final Category item;
  final bool isSelected;
  final Function(Category) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => onTap(item),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(item.name ?? ''))
            ],
          ),
        ),
      ),
    );
  }
}
