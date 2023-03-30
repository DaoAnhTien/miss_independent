import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/shop/bloc/product_detail_cubit.dart';
import 'package:miss_independent/modules/shop/bloc/product_detail_state.dart';
import '../../../common/constants/routes.dart';
import '../../../common/enums/status.dart';
import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../models/product.dart';
import '../../../widgets/cached_image.dart';
import '../widgets/product_detail_body.dart';
import '../widgets/product_detail_footer.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentQuantity = 1;

  void increaseQuantity(int maxQuantity) {
    if (_currentQuantity < maxQuantity) {
      setState(() {
        _currentQuantity++;
      });
    }
  }

  void decreaseQuantity() {
    if (_currentQuantity > 1) {
      setState(() {
        _currentQuantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    final Product? product = context.getRouteArguments<Product>();
    return BlocProvider(
      create: (_) => getIt<ProductDetailCubit>()
        ..init(product)
        ..fetchItems(),
      child: BlocConsumer<ProductDetailCubit, ProductDetailState>(
        listenWhen: (previous, current) =>
            previous.addToCartStatus != current.addToCartStatus ||
            previous.buyNowStatus != current.buyNowStatus,
        listener: (context, state) {
          if (state.addToCartStatus == RequestStatus.success) {
            showSuccessMessage(context,
                "${state.product?.name} ${S.of(context).addedToCartSuccesfully}");
          }
          if (state.addToCartStatus == RequestStatus.failed &&
              state.message?.isNotEmpty == true) {
            showErrorMessage(context, state.message!);
          }
          if (state.buyNowStatus == RequestStatus.failed &&
              state.message?.isNotEmpty == true) {
            showErrorMessage(context, state.message!);
          }
        },
        builder: (context, state) => Scaffold(
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: kDarkGreyColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      floating: false,
                      centerTitle: true,
                      elevation: 1,
                      backgroundColor: kWhiteColor,
                      flexibleSpace: FlexibleSpaceBar(
                        background: CachedImage(
                          fit: BoxFit.cover,
                          url: state.product?.image,
                          width: widthScreen,
                          height: widthScreen,
                        ),
                      ),
                      expandedHeight: widthScreen,
                      pinned: true,
                    ),
                    ProductDetailBody(product: state.product),
                  ],
                ),
              ),
              ProductDetailFooter(
                currentQuantity: _currentQuantity,
                buyNow: () => _onBuyNow(context),
                decreaseQuantity: () => decreaseQuantity(),
                increaseQuantity: () =>
                    increaseQuantity(state.product?.quantity ?? 0),
                addToCart: () => _onAddToCart(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onAddToCart(BuildContext context) {
    context.read<ProductDetailCubit>().addToCart();
  }

  _onBuyNow(BuildContext context) async {
    await context.read<ProductDetailCubit>().addToCart(isBuyNow: true);
    if (context.mounted) {
      Navigator.pushNamed(context, kCartRoute);
    }
  }
}
