import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ExpensesDetails extends StatelessWidget {
  ExpensesDetails(
      {Key? key,
      required this.controller,
      required this.label,
      this.inputFormatters,
      this.keyboardType})
      : super(key: key);
  final TextEditingController? controller;
  final String label;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          // SizedBox(height: 20),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Fill in this field";
              }
              return null;
            },
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              label: Text(label),
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
