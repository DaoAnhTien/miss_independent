import 'package:flutter/material.dart';
import 'package:miss_independent/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key, required this.category, required this.onTap})
      : super(key: key);
  final Category category;
  final Function(Category) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(category);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(category.name ?? ""),
      ),
    );
  }
}
