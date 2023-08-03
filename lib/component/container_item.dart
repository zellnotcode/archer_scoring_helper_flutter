import 'package:flutter/material.dart';

import '../constant/color.dart';

class ContainerItem extends StatelessWidget {
  final Widget? child;
  final double height;

  const ContainerItem({super.key, this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: height,
        decoration: const BoxDecoration(
          color: CustomColor.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: child);
  }
}
