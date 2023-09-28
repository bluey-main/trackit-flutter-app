import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/total_expense.dart';
import '../components/expenses.dart';
import '../components/expenses_details.dart';
import '../widgets/expense_list_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/budget_database.dart';
import '../database/total_budget_database.dart';

class BudgeterPage extends StatefulWidget {
  const BudgeterPage({super.key});

  @override
  State<BudgeterPage> createState() => _BudgeterPageState();
}

class _BudgeterPageState extends State<BudgeterPage> {
  //reference the box
  final _budgetBox = Hive.box("secondBox");
  final _totalBudgetBox = Hive.box("totalBudgetBox");

  double budgetRemainder = 0;
  BudgetTrackerDatabase db = BudgetTrackerDatabase();
  TotalBudgetDatabase totalBudgetdb = TotalBudgetDatabase();
  final budgetNameValue = TextEditingController();
  final budgetCostValue = TextEditingController();
  final budgetValue = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //Set Budget List On load
    if (_budgetBox.get("BUDGETLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    //Set Total Budget on Load
    if (_totalBudgetBox.get("TOTALBUDGET") == null) {
      totalBudgetdb.allBudgetSum = 0;
    } else {
      totalBudgetdb.loadData();
    }
    super.initState();
    updateBudgetRemainder();
  }

  //call two functions at once
  void callAllFunctions() {
    subtractAllExpenses();
    updateBudgetRemainder();
  }

  //clear the Text fields after input
  void clearTextField() {
    budgetCostValue.clear();
    budgetNameValue.clear();
  }

  //Update budget remainder
  void updateBudgetRemainder() {
    setState(
      () {
        budgetRemainder = totalBudgetdb.allBudgetSum;
      },
    );
  }

  //removes expenses from total budget
  void subtractAllExpenses() {
    setState(
      () {
        for (var element in db.budgetList) {
          totalBudgetdb.allBudgetSum -= element.values.elementAt(1);
        }
      },
    );
  }

  //removes the last element in the list if it is above the remaining budget
  void removeExcessBudget() {
    if (totalBudgetdb.allBudgetSum < 0) {
      totalBudgetdb.allBudgetSum += db.budgetList.last.values.elementAt(1);
      db.budgetList.remove(db.budgetList.last);
      updateBudgetRemainder();

      db.updateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),

      //places all floating action buttons to the base of the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      //all floating action buttons
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          //TWO FLOATING ACTION BUTTTON
          children: <Widget>[
            //floating action button to set your budget
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  //dialog box to set your budget
                  myBudgetValueDialog(context);
                });
              },
              child: const Text(
                r'$',
                style: TextStyle(fontSize: 30),
              ),
            ),

            //separation for the action buttons
            const SizedBox(height: 20),

            //floating action button to add items
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  //checks if your budget is 0 or below 0 and shows a dialog box the says your budget is low
                  if (totalBudgetdb.allBudgetSum == 0 ||
                      totalBudgetdb.allBudgetSum.isNegative) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: Text('Your Budget is Too Low'),
                          );
                        });
                  } else {
                    //if the budget is above 0 it allows the user to add items
                    myDialogBox(context);
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),

      //Body of the app
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //A custom component
                TotalExpense(totalExpense: budgetRemainder),
                // SizedBox(height: ),
                Expenses(
                  itemBuilder: (context, index) {
                    return ExpenseListTile(
                        color: index % 2 == 0
                            ? Colors.blue.shade300
                            : Colors.blue.shade100,
                        onTap: () {
                          setState(() {
                            totalBudgetdb.allBudgetSum += db.budgetList
                                .elementAt(index)
                                .values
                                .elementAt(1);
                            db.budgetList.removeAt(index);
                            updateBudgetRemainder();
                            totalBudgetdb.updateData();

                            db.updateData();
                          });
                        },
                        expense: db.budgetList[index]['expenseName'],
                        cost: db.budgetList[index]['expenseCost'].toString());
                  },
                  itemCount: db.budgetList.length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> myBudgetValueDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Enter Your The Amount You Have',
                  textAlign: TextAlign.center),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        if (budgetValue.text != '' ||
                            budgetValue.text.isNotEmpty) {
                          clearTextField();
                          totalBudgetdb.allBudgetSum =
                              double.parse(budgetValue.text);
                          subtractAllExpenses();
                          updateBudgetRemainder();
                          totalBudgetdb.updateData();
                        }

                        db.updateData();

                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    );
                  },
                  child: const Text('Set Budget'),
                ),
              ],
              content: Wrap(
                children: [
                  SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        ExpensesDetails(
                          controller: budgetValue,
                          label: "How Much Do You Have",
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                                controller: budgetNameValue,
                                label: 'Expense Name'),
                            ExpensesDetails(
                              controller: budgetCostValue,
                              label: "Expense Cost",
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
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
                          db.budgetList.add(
                            {
                              'expenseName': budgetNameValue.text,
                              'expenseCost': int.parse(budgetCostValue.text),
                            },
                          );
                          clearTextField();
                          totalBudgetdb.allBudgetSum -=
                              db.budgetList.last.values.elementAt(1);
                          updateBudgetRemainder();
                          removeExcessBudget();
                          totalBudgetdb.updateData();

                          db.updateData();

                          Navigator.of(context, rootNavigator: true)
                              .pop(db.budgetList);
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
