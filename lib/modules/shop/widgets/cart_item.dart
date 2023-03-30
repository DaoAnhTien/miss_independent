import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miss_independent/common/constants/routes.dart';

import '../../../common/theme/colors.dart';
import '../../../common/utils/utils.dart';
import '../../../models/cart.dart';
import '../../../widgets/cached_image.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.editQuantity,
  });
  final Cart item;
  final Function(int quantity) editQuantity;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void _onChangedQuantity(int quantity) {
    widget.editQuantity(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, kProductDetailRoute,
          arguments: widget.item.product),
      child: Row(
        children: [
          CachedImage(
            url: widget.item.product?.image,
            height: 88,
            width: 88,
            fit: BoxFit.cover,
            radius: 6,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.product?.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      widget.item.product?.price != null
                          ? formatCurrency(widget.item.product!.price!) ?? ""
                          : "",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    QuantityInput(
                        onChanged: _onChangedQuantity,
                        quantity: widget.item.quantity ?? 1)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityInput extends StatelessWidget {
  const QuantityInput(
      {Key? key, required this.onChanged, required this.quantity})
      : super(key: key);
  final Function(int) onChanged;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: kLightGreyColor),
              borderRadius: BorderRadius.circular(2)),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      onChanged(quantity - 1);
                    }
                  },
                  icon: const Icon(CupertinoIcons.minus, size: 10)),
              const SizedBox(width: 4),
              Text(quantity.toString()),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: () {
                    onChanged(quantity + 1);
                  },
                  icon: const Icon(CupertinoIcons.add, size: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
