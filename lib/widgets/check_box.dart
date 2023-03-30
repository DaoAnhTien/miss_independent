import 'package:flutter/material.dart';
import 'package:miss_independent/common/theme/colors.dart';

class CheckBox extends StatelessWidget {
  const CheckBox({super.key, this.isChecked = false, required this.onChanged});
  final bool isChecked;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return kPrimaryColor;
      }
      return Colors.black;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: onChanged,
    );
  }
}
