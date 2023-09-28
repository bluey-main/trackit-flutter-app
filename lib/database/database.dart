import 'package:hive_flutter/hive_flutter.dart';

class ExpenseTrackerDataBase {
  List expenseList = [
    // {'expenseName': 'food', 'expenseCost': 200},
    // {'expenseName': 'drink', 'expenseCost': 200},
  ];
  //reference the box
  final _firstBox = Hive.box("firstBox");


  //Create Data
  void createInitialData(){
    expenseList = [
    {'expenseName': 'DEMO', 'expenseCost': 100},
    // {'expenseName': 'drink', 'expenseCost': 200},
  ];
  }
  //Load data from Database
  void loadData() {
    expenseList = _firstBox.get("EXPENSELIST");
  }

  // update Database
  void updateData() {
    _firstBox.put("EXPENSELIST", expenseList);
  }
}
