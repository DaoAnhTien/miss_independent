import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/category.dart';
import 'package:miss_independent/modules/shop/bloc/cart_cubit.dart';
import 'package:miss_independent/modules/shop/bloc/cart_state.dart';
import 'package:miss_independent/modules/shop/bloc/shop_cubit.dart';
import 'package:miss_independent/modules/shop/bloc/shop_state.dart';
import 'package:miss_independent/modules/shop/widgets/product_item.dart';

import '../../../common/theme/colors.dart';
import '../../../models/pagination.dart';
import '../../../widgets/list_content_grid_view.dart';
import '../widgets/icon_btn_with_counter.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({Key? key}) : super(key: key);

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double padding = 8;
    int countItems = 2;
    double widthItem = (widthScreen - (countItems + 1) * padding) / countItems;
    double heightImg = widthItem * 4 / 3;
    double heightBottom = 100.0;
    double heightItem = heightImg + heightBottom;

    Category? category = context.getRouteArguments<Category>();

    return Scaffold(
        appBar: AppBar(
          title: Text(category?.name ?? ''),
          actions: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) => IconBtnWithCounter(
                press: () => Navigator.pushNamed(context, kCartRoute),
                icon: const Icon(CupertinoIcons.cart),
                numOfitem: state.carts?.length ?? 0,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocProvider<ShopCubit>(
            create: (_) => getIt<ShopCubit>()
              ..setCategoryId(category?.id)
              ..refreshItems(isInit: true),
            child: BlocConsumer<ShopCubit, ShopState>(
                listenWhen: (previous, current) =>
                    previous.addToCartStatus != current.addToCartStatus,
                listener: (context, state) {
                  if (state.addToCartStatus == RequestStatus.success) {
                    showSuccessMessage(
                        context, S.of(context).productAddedToCartSuccesfully);
                  }
                  if (state.addToCartStatus == RequestStatus.failed &&
                      state.message?.isNotEmpty == true) {
                    showErrorMessage(context, state.message!);
                  }
                },
                builder: (BuildContext context, ShopState state) {
                  if ([
                    DataSourceStatus.initial,
                    DataSourceStatus.refreshing,
                    DataSourceStatus.loading
                  ].contains(state.status)) {
                    return const Center(
                        child: SpinKitWave(
                      color: kPrimaryColor,
                      size: 20.0,
                    ));
                  }

                  return ListContentGridView(
                    padding: padding,
                    countItems: countItems,
                    widthItem: widthItem,
                    status: state.status,
                    errMsg: state.message,
                    heightItem: heightItem,
                    onRefresh: () => _onRefresh(context),
                    onLoadMore: () => _onLoadMore(context),
                    children:
                        List.generate(state.products?.length ?? 0, (index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, kProductDetailRoute,
                                arguments: state.products![index]);
                          },
                          child: ProductItem(
                            addToCart: (int id) =>
                                context.read<ShopCubit>().addToCart(id),
                            product: state.products![index],
                            widthItem: widthItem,
                            heightBottom: heightBottom,
                          ));
                    }),
                  );
                })));
  }

  _onRefresh(BuildContext context) {
    context.read<ShopCubit>().refreshItems();
  }

  _onLoadMore(BuildContext context) {
    context.read<ShopCubit>().loadMoreItems();
  }
}
