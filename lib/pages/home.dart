import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/total_expense.dart';
import '../components/expenses.dart';
import '../components/expenses_details.dart';
import '../widgets/expense_list_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //REFRENCE THE BOX
  final _firstBox = Hive.box("firstBox");

  ExpenseTrackerDataBase db = ExpenseTrackerDataBase();
  double totalExpense = 0;
  double allExpensesSum = 0;
  final expenseNameValue = TextEditingController();
  final expenseCostValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (_firstBox.get("EXPENSELIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
    callAllFunctions();
  }

  void callAllFunctions() {
    sumAllExpenses();
    updateTotalExpense();
  }

  void clearTextField() {
    expenseCostValue.clear();
    expenseNameValue.clear();
  }

  void updateTotalExpense() {
    setState(() {
      totalExpense = allExpensesSum;
      db.updateData();
    });
  }

  void sumAllExpenses() {
    setState(() {
      for (var element in db.expenseList) {
        allExpensesSum += element.values.elementAt(1);
        db.updateData();
      }

      // print(expenseList.last.values.elementAt(1));
      // expenseList.forEach((element) {
      //   print(element.values.elementAt(1));
      //   allExpensesSum += element.values.elementAt(1);
      //   print(allExpensesSum);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            myDialogBox(context);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TotalExpense(totalExpense: totalExpense),
                Expenses(
                  itemBuilder: (context, index) {
                    return ExpenseListTile(
                        color: index % 2 == 0
                            ? Colors.blue.shade200
                            : Colors.blue.shade50,
                        onTap: () {
                          setState(() {
                            allExpensesSum -= db.expenseList
                                .elementAt(index)
                                .values
                                .elementAt(1);
                            db.expenseList.removeAt(index);
                            updateTotalExpense();
                            db.updateData();
                          });
                        },
                        expense: db.expenseList[index]['expenseName'],
                        cost: db.expenseList[index]['expenseCost'].toString());
                  },
                  itemCount: db.expenseList.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> myDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Enter Your Details'),
                content: SizedBox(
                  height: 150,
                  child: Form(
                    key: _formKey,
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            ExpensesDetails(
                                controller: expenseNameValue,
                                label: 'Expense Name'),
                            ExpensesDetails(
                              controller: expenseCostValue,
                              label: "Expense Cost",
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_formKey.currentState!.validate()) {
                          db.expenseList.add(
                            {
                              'expenseName': expenseNameValue.text,
                              'expenseCost': int.parse(expenseCostValue.text),
                            },
                          );
                          clearTextField();
                          allExpensesSum +=
                              db.expenseList.last.values.elementAt(1);
                          updateTotalExpense();
                          db.updateData();

                          Navigator.of(context, rootNavigator: true)
                              .pop(db.expenseList);
                        }
                      });
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade300)),
                    onPressed: () {
                      setState(() {
                        clearTextField();

                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
