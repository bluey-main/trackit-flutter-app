import 'package:flutter/material.dart';

class TotalExpense extends StatelessWidget {
  const TotalExpense({Key? key, required this.totalExpense}) : super(key: key);
  final double totalExpense;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      width: double.infinity,
      height: 100,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 3.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        "₦ $totalExpense",
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
      ),
    );
  }
}
