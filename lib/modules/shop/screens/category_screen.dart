import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/models/category.dart';
import 'package:miss_independent/widgets/list_content.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_state.dart';
import '../widgets/category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
   @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => context.read<CartCubit>().fetchItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CategoryCubit>(
        create: (_) => getIt<CategoryCubit>()..getCategories(),
        child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (BuildContext context, CategoryState state) {
          return ListContent<Category>(
            list: state.categories,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            status: state.status,
            onRefresh: () => _onRefresh(context),
            separatorWidget: const Divider(),
            itemBuilder: (Category item) {
              return CategoryItem(
                category: item,
                onTap: (Category item) {
                  Navigator.pushNamed(context, kShopRouter, arguments: item);
                },
              );
            },
          );
        }),
      ),
    );
  }

  void _onRefresh(BuildContext context) {
    context.read<CategoryCubit>().getCategories();
  }
}
