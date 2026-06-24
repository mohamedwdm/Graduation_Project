import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/slots_cubit/slots_cubit.dart';
import 'widgets/slots_view_body.dart';

class SlotsView extends StatelessWidget {
  const SlotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SlotsCubit>()..loadSlots(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const SafeArea(
          child: SlotsViewBody(),
        ),
      ),
    );
  }
}
