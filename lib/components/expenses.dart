import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key? key, required this.itemCount, required this.itemBuilder})
      : super(key: key);
  final Widget? Function(BuildContext, int) itemBuilder;
  final int? itemCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 100,
        top: 20,
      ),
      width: double.infinity,
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}
