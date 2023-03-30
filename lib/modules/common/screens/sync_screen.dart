import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/routes.dart';
import '../../../di/injection.dart';
import '../../../widgets/loading_indicator.dart';
import '../../auth/bloc/auth_cubit.dart';
import '../../auth/bloc/auth_state.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AuthState state = getIt<AuthCubit>().state;
      _listener(context, state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: _listener,
        child: const Center(child: LoadingIndicator()),
      ),
    );
  }

  void _listener(context, AuthState state) {
    if ((state.token?.isNotEmpty ?? false) &&
        state.isNotCreatedProfile != false) {
      Navigator.of(context).pushReplacementNamed(kMainRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(kLoginRoute);
    }
  }
}
