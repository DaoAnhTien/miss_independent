import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/cart.dart';
import 'package:miss_independent/modules/shop/bloc/cart_cubit.dart';
import 'package:miss_independent/modules/shop/bloc/cart_state.dart';
import 'package:miss_independent/widgets/button.dart';
import 'package:miss_independent/widgets/list_content.dart';

import '../../../common/utils/toast.dart';
import '../../../common/utils/utils.dart';
import '../../../models/pagination.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.deleteStatus != current.deleteStatus ||
          previous.editStatus != current.editStatus,
      listener: (context, state) {
        if ((state.status == DataSourceStatus.failed ||
                state.deleteStatus == RequestStatus.failed ||
                state.editStatus == RequestStatus.failed) &&
            state.message?.isNotEmpty == true) {
          showErrorMessage(context, state.message!);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).cart),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListContent<Cart>(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  status: state.status,
                  list: state.carts,
                  onRefresh: () => _onRefresh(context),
                  itemBuilder: (Cart item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _onDelete(context, item.id ?? 0,
                              state.carts?.indexOf(item) ?? -1);
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: kErrorBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: const [
                              Spacer(),
                              Icon(
                                CupertinoIcons.delete_solid,
                                color: kErrorRedColor,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                        child: CartItem(
                          item: item,
                          editQuantity: (quantity) => _onEditQuantity(
                              context,
                              item.id ?? 0,
                              quantity,
                              state.carts?.indexOf(item) ?? -1),
                        ),
                      ),
                    );
                  }),
            ),
            (state.carts?.isNotEmpty ?? false)
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    // height: 174,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -15),
                          blurRadius: 20,
                          color: const Color(0xFFDADADA).withOpacity(0.15),
                        )
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "${S.of(context).total}:\n",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: formatCurrency(state.totalPrice),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                  ],
                                ),
                              ),
                              BasicButton(
                                label: S.of(context).checkout,
                                onPressed: () => Navigator.pushNamed(
                                    context, kCheckOutRoute, arguments: {
                                  "totalPrice": state.totalPrice,
                                  "totalItem": state.carts?.length
                                }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _onRefresh(BuildContext context) {
    context.read<CartCubit>().fetchItems();
  }

  void _onDelete(BuildContext context, int id, int index) async {
    await context.read<CartCubit>().deleteCart(id);
  }

  void _onEditQuantity(
      BuildContext context, int id, int quantity, int index) async {
    await context.read<CartCubit>().editQuantity(id, quantity);
  }
}
