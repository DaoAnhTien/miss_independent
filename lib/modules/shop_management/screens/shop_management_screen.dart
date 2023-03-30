import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/modules/shop_management/bloc/shop_management_cubit.dart';
import 'package:miss_independent/modules/shop_management/bloc/shop_management_state.dart';
import '../../../di/injection.dart';
import '../../../models/product.dart';
import '../../../widgets/list_content_grid_view.dart';
import '../../shop/widgets/product_item.dart';

class ShopManagementScreen extends StatefulWidget {
  const ShopManagementScreen({Key? key}) : super(key: key);

  @override
  State<ShopManagementScreen> createState() => _ShopManagementScreenState();
}

class _ShopManagementScreenState extends State<ShopManagementScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double padding = 8;
    int countItems = 2;
    double widthItem = (widthScreen - (countItems + 1) * padding) / countItems;
    double heightImg = widthItem * 4 / 3;
    double heightBottom = 80.0;
    double heightItem = heightImg + heightBottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).shopManagement),
      ),
      body: BlocProvider<ShopManagementCubit>(
        create: (_) => getIt<ShopManagementCubit>()..refreshItems(isInit: true),
        child: BlocConsumer<ShopManagementCubit, ShopManagementState>(
            listenWhen: (previous, current) =>
                previous.status != current.status ||
                previous.deleteStatus != current.deleteStatus,
            listener: (context, state) {
              if (state.status == DataSourceStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
              if (state.deleteStatus == RequestStatus.failed &&
                  state.message?.isNotEmpty == true) {
                showErrorMessage(context, state.message!);
              }
              if (state.deleteStatus == RequestStatus.success) {
                showSuccessMessage(
                    context, S.of(context).thisProductWasDeleted);
              }
            },
            builder: (BuildContext context, ShopManagementState state) {
              return ListContentGridView(
                  status: state.status,
                  errMsg: state.message,
                  countItems: countItems,
                  heightItem: heightItem,
                  padding: padding,
                  widthItem: widthItem,
                  onRefresh: () => _onRefresh(context),
                  onLoadMore: () => _onLoadMore(context),
                  children: List.generate(state.products?.length ?? 0, (index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, kProductDetailRoute,
                              arguments: state.products![index]);
                        },
                        child: ProductItem(
                          isFromManagement: true,
                          product: state.products![index],
                          widthItem: widthItem,
                          deleteProduct: (Product product) =>
                              _deleteProduct(context, product.id ?? 0),
                          heightBottom: heightBottom,
                        ));
                  }));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, kAddShopRoute);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onRefresh(BuildContext context) {
    context.read<ShopManagementCubit>().refreshItems();
  }

  void _onLoadMore(BuildContext context) {
    context.read<ShopManagementCubit>().loadMoreItems();
  }

  void _deleteProduct(BuildContext context, int id) async {
    context.read<ShopManagementCubit>().deleteProduct(id);
  }
}
