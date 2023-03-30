import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:miss_independent/common/utils/extensions/datetime_extension.dart';

import '../../../common/theme/colors.dart';
import '../../../common/utils/utils.dart';
import '../../../generated/l10n.dart';
import '../../../models/order.dart';
import '../../../widgets/cached_image.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.isFromManagement = false,
  });
  final OrderModel order;
  final bool isFromManagement;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      decoration: BoxDecoration(
          border: Border.all(color: kGreyColor),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.createdAt?.toTimeAgo().toUpperCase() ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${S.of(context).status}: ${order.status}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatCurrency(order.totalPrice ?? 0) ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "${order.quantity.toString()} ${S.of(context).items}"),
                    ],
                  ),
                  const Icon(Icons.keyboard_arrow_right_outlined),
                ],
              ),
            ],
          ),
          const Divider(color: kDarkGreyColor),
          Container(
            decoration: BoxDecoration(
                color: kLightGreyColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                SizedBox(
                  height: 96,
                  width: MediaQuery.of(context).size.width - 58,
                  child: Swiper(
                    itemBuilder: (context, index) {
                      final item = order.details?[index];
                      return Row(
                        children: [
                          CachedImage(
                            url: item?.product?.image,
                            fit: BoxFit.cover,
                            radius: 8,
                            width: 96,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item?.product?.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(TextSpan(
                                  text: item?.product?.price != null
                                      ? formatCurrency(item!.product!.price!) ??
                                          ""
                                      : "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: " x${item?.quantity}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall)
                                  ])),
                            ],
                          ))
                        ],
                      );
                    },
                    itemCount: order.details?.length ?? 0,
                    autoplay: false,
                    physics: (order.details?.length ?? 0) > 1
                        ? null
                        : const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    pagination: const SwiperPagination(
                        alignment: Alignment.bottomRight,
                        builder: SwiperPagination.dots),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
