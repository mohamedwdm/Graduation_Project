import 'package:flutter/widgets.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorMessege});

  final String errorMessege;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorMessege, style: const TextStyle(fontSize: 16)),
    );
  }
}
