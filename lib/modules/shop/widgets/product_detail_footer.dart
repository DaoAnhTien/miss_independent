import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/theme/colors.dart';

import '../../../common/enums/status.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/button.dart';
import '../bloc/product_detail_cubit.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailFooter extends StatelessWidget {
  const ProductDetailFooter({
    super.key,
    required this.currentQuantity,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.addToCart,
    required this.buyNow,
  });
  final int currentQuantity;
  final Function() addToCart;
  final Function() buyNow;
  final VoidCallback increaseQuantity;
  final VoidCallback decreaseQuantity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).selectTheQuantity),
                Row(
                  children: [
                    GestureDetector(
                      onTap: decreaseQuantity,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            border: Border.all(color: kLightGreyColor),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                            child: Text(
                          "-",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kWhiteColor),
                        )),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 24,
                      width: 48,
                      decoration: BoxDecoration(
                          border: Border.all(color: kLightGreyColor),
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(currentQuantity.toString()),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: increaseQuantity,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            border: Border.all(color: kGreyColor),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                            child: Text(
                          "+",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kWhiteColor),
                        )),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: BasicButton(
                      onPressed: buyNow,
                      disabled: (state.product?.quantity ?? 0) < 1,
                      label: S.of(context).buyNow,
                      isLoading:
                          state.buyNowStatus == RequestStatus.requesting),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BasicButton(
                      backgroundColor: kLightGreyColor,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: (state.product?.quantity ?? 0) < 1
                                  ? Colors.black26
                                  : kBlackColor),
                      onPressed: addToCart,
                      label: S.of(context).addToCart.toUpperCase(),
                      disabled: (state.product?.quantity ?? 0) < 1,
                      isLoading:
                          state.addToCartStatus == RequestStatus.requesting),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 
}

