import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({
    Key? key,
    required this.expense,
    required this.cost,
    required this.onTap,
    this.color
  }) : super(key: key);

  final String expense;
  final String cost;
  final Function()? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 70,
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "₦$cost",
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
     
        const SizedBox(height: 10),
      ],
    );
  }
}
