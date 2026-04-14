import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../manager/find_car_cubit/find_car_cubit.dart';
import 'package:go2car/features/find_car/presentation/views/widgets/find_car_view_body.dart';

class FindCarView extends StatelessWidget {
  const FindCarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FindCarCubit>()..findMyCar(),
      child: const Scaffold(
        body: SafeArea(child: FindCarViewBody()),
        backgroundColor: Color(0xffF6F8F6),
      ),
    );
  }
}
