import 'package:flutter/material.dart';

import 'package:go2car/features/slots/presentation/views/widgets/slots_view_body.dart';

class SlotsView extends StatelessWidget {
  const SlotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SlotsViewBody()),
      backgroundColor: Color(0xffFFFFFF),
    );
  }
}
