import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../common/theme/colors.dart';
import '../../../common/utils/utils.dart';
import '../../../generated/l10n.dart';
import '../../../models/product.dart';

class ProductDetailBody extends StatelessWidget {
  const ProductDetailBody({super.key, this.product});
  final Product? product;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    product?.name ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: kBlackColor),
                  ),
                ),
                Text(
                  product?.price != null
                      ? formatCurrency(product!.price!) ?? ""
                      : "",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  itemSize: 24,
                  initialRating: 3.2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rate_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: kGreyColor, width: 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        S.of(context).description,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Text(
                      product?.description ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: kGreyColor, width: 1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(S.of(context).specifications,
                        style: Theme.of(context).textTheme.displayMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).weight,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Text(product?.weight?.toString() ?? "")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).quantity,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(product?.quantity?.toString() ?? "")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
