import 'package:flutter/material.dart';

class CheckBoxItem extends StatelessWidget {
  const CheckBoxItem(
      {Key? key,
      required this.label,
      required this.value,
      required this.onChanged})
      : super(key: key);
  final Widget label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Icon(value ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 20),
              const SizedBox(width: 10),
              Expanded(child: label)
            ],
          ),
        ),
      ),
    );
  }
}
