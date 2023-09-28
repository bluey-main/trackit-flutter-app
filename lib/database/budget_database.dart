import 'package:hive_flutter/hive_flutter.dart';

class BudgetTrackerDatabase {
  List budgetList = [
    // {'expenseName': 'food', 'expenseCost': 200},
    // {'expenseName': 'drink', 'expenseCost': 200},
  ];
  final _secondBox = Hive.box("secondBox");

  void createInitialData() {
    budgetList = [
      {'expenseName': 'food', 'expenseCost': 200},
      // {'expenseName': 'drink', 'expenseCost': 200},
    ];
  }

  //load data
  void loadData() {
    budgetList = _secondBox.get("BUDGETLIST");
  }

  //update data
  void updateData() {
    _secondBox.put("BUDGETLIST", budgetList);
  }
}
