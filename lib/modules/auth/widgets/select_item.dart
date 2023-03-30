import 'package:flutter/material.dart';

class SelectItem extends StatelessWidget {
  const SelectItem(
      {Key? key,
      required this.item,
      required this.isSelected,
      required this.onTap})
      : super(key: key);
  final Map<String, String> item;
  final bool isSelected;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => onTap(item['code'] ?? ''),
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
              Expanded(child: Text(item['name'] ?? ''))
            ],
          ),
        ),
      ),
    );
  }
}
