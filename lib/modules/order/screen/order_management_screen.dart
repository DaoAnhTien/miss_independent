import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/order.dart';
import 'package:miss_independent/widgets/list_content.dart';
import '../../../models/pagination.dart';
import '../bloc/order_management_cubit.dart';
import '../bloc/order_management_state.dart';
import '../widgets/order_item.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).orderManagement),
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<OrderManagementCubit>()..refreshItems(isInit: true),
        child: BlocConsumer<OrderManagementCubit, OrderManagementState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == DataSourceStatus.failed &&
                state.message?.isNotEmpty == true) {
              showErrorMessage(context, state.message!);
            }
          },
          builder: (context, state) => ListContent<OrderModel>(
            onRefresh: () => _onRefresh(context),
            onLoadMore: () => _onLoadMore(context),
            status: state.status,
            errMsg: state.message,
            list: state.orders,
            itemBuilder: (OrderModel order) =>
                OrderItem(order: order, isFromManagement: true),
          ),
        ),
      ),
    );
  }

  _onLoadMore(BuildContext context) {
    context.read<OrderManagementCubit>().loadMoreItems();
  }

  _onRefresh(BuildContext context) {
    context.read<OrderManagementCubit>().refreshItems();
  }
}
