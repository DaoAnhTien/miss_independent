import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/product.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import 'package:miss_independent/common/utils/utils.dart';

import '../../../widgets/custom_alert_dialog.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key,
      required this.product,
      required this.widthItem,
      required this.heightBottom,
      this.isFromManagement = false,
      this.addToCart,
      this.deleteProduct})
      : super(key: key);
  final Product product;
  final double widthItem;
  final double heightBottom;
  final Function(int id)? addToCart;
  final Function(Product)? deleteProduct;
  final bool isFromManagement;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              CachedImage(
                fit: BoxFit.cover,
                url: product.image,
                width: widthItem,
                height: widthItem * 4 / 3,
                radius: 4,
              ),
              if (isFromManagement)
                Positioned(
                    right: 0,
                    top: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, kAddShopRoute,
                                  arguments: product);
                            },
                            icon: const Icon(
                              CupertinoIcons.pencil,
                              size: 22,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () {
                              customAppDialog(
                                context,
                                title: S.of(context).deleteProduct,
                                icon: const Icon(
                                  CupertinoIcons.trash,
                                  color: kErrorRedColor,
                                  size: 25,
                                ),
                                textConfirmColor: kErrorRedColor,
                                text: S
                                    .of(context)
                                    .areYouSureYouWantToDeleteThisProduct,
                                onConfirm: () async {
                                  await deleteProduct?.call(product);
                                },
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.delete,
                              size: 20,
                              color: Colors.red,
                            ))
                      ],
                    ))
            ],
          ),
          SizedBox(
              height: heightBottom,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            product.price != null
                                ? formatCurrency(product.price!) ?? ""
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (!isFromManagement)
                          Theme(
                            data: ThemeData(
                              splashColor: (product.quantity ?? 0) > 0
                                  ? kLightPrimaryColor
                                  : Colors.transparent,
                              highlightColor: (product.quantity ?? 0) > 0
                                  ? kLightPrimaryColor
                                  : Colors.transparent,
                            ),
                            child: InkWell(
                              onTap: () {
                                if ((product.quantity ?? 0) > 0) {
                                  addToCart?.call(product.id ?? 0);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  CupertinoIcons.cart_fill_badge_plus,
                                  color: (product.quantity ?? 0) > 0
                                      ? kPrimaryColor
                                      : kGreyColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!isFromManagement)
                      Text(
                        (product.quantity ?? 0) > 0
                            ? S.of(context).inStock
                            : S.of(context).outOfStock,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: (product.quantity ?? 0) > 0
                                ? kPrimaryColor
                                : kErrorRedColor),
                      ),
                  ],
                ),
              )),
        ]);
  }
}
