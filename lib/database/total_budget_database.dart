import 'package:hive_flutter/hive_flutter.dart';

class TotalBudgetDatabase {
  final _totalBudgetBox = Hive.box("totalBudgetBox");

  double allBudgetSum = 0;

  //load data
  void loadData() {
    allBudgetSum = _totalBudgetBox.get("TOTALBUDGET");
  }

  //UPDATE DATA
  void updateData() {
    _totalBudgetBox.put("TOTALBUDGET", allBudgetSum);
  }
}
