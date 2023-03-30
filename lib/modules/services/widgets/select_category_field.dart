import 'package:flutter/material.dart';
import 'package:miss_independent/models/pagination.dart';

import '../../../generated/l10n.dart';
import '../../../models/category.dart';
import '../../../widgets/list_bundle.dart';

class SelectCategoryField extends StatelessWidget {
  const SelectCategoryField(
      {Key? key,
      this.label,
      required this.categories,
      this.controller,
      this.validator,
      this.enabled,
      required this.onSelected,
      this.onClear,
      this.mandatory})
      : super(key: key);
  final String? label;
  final List<Category> categories;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final bool? mandatory;
  final Function(Category) onSelected;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label?.isNotEmpty ?? false)
          Row(
            children: [
              Text(
                label!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if (mandatory ?? false) const SizedBox(width: 1),
              if (mandatory ?? false)
                Text('*',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.red)),
            ],
          ),
        if (label?.isNotEmpty ?? false) const SizedBox(height: 10.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: TextFormField(
            onTap: () => _showSearchItems(context),
            readOnly: true,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: S.of(context).selectCategory,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              filled: true,
              border: InputBorder.none,
            ),
            enabled: enabled,
          ),
        )
      ],
    );
  }

  void _showSearchItems(BuildContext context) {
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
                  categories: categories,
                  onSelected: onSelected,
                )),
          ),
        );
      },
    );
  }
}

class SelectItemPopup extends StatefulWidget {
  const SelectItemPopup(
      {Key? key, required this.categories, required this.onSelected})
      : super(key: key);
  final List<Category> categories;
  final Function(Category) onSelected;

  @override
  State<SelectItemPopup> createState() => _SelectItemPopupState();
}

class _SelectItemPopupState extends State<SelectItemPopup> {
  late List<Category> _items = widget.categories;

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
                    return SearchItem(item: item, onTap: _onClickItem);
                  }),
            ),
          ),
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
    widget.onSelected(item);
    Navigator.pop(context);
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({Key? key, required this.item, required this.onTap})
      : super(key: key);
  final Category item;
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
            children: [Expanded(child: Text(item.name ?? ''))],
          ),
        ),
      ),
    );
  }
}
