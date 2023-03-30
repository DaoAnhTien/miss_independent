import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/models/order.dart';
import 'package:miss_independent/modules/order/bloc/order_history_state.dart';
import 'package:miss_independent/widgets/list_content.dart';
import '../../../models/pagination.dart';
import '../bloc/order_history_cubit.dart';
import '../widgets/order_item.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).orderHistory),
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<OrderHistoryCubit>()..refreshItems(isInit: true),
        child: BlocConsumer<OrderHistoryCubit, OrderHistoryState>(
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
            itemBuilder: (OrderModel order) => OrderItem(order: order),
          ),
        ),
      ),
    );
  }

  _onLoadMore(BuildContext context) {
    context.read<OrderHistoryCubit>().loadMoreItems();
  }

  _onRefresh(BuildContext context) {
    context.read<OrderHistoryCubit>().refreshItems();
  }
}
