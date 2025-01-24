import 'package:flutter/material.dart';
import 'package:tracker/widgets/chart/chart.dart';
import 'package:tracker/widgets/expenses_list/expenses_list.dart';
import 'package:tracker/model/expense.dart';
import 'package:tracker/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "flutter",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "cinema",
        amount: 15.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
        useSafeArea:
            true, // make sure that the camera doesn't overlay my sheet modal and flutter take note where is the camera and will adjust height
        context: context,
        isScrollControlled: true,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
    ();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context)
        .size
        .width; // adjust my screen to be rotated and defferent size

    Widget mainContent = const Center(
      child: Text('no expenses found. Start adding some!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter ExpenseTracker'),
          actions: [
            IconButton(
                onPressed: _openAddExpensesOverlay, icon: const Icon(Icons.add))
          ],
        ),
        body: width < 600 // adjust my screen to be rotated and defferent size
            ? Column(children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ])
            : Row(
                // adjust my screen to be rotated and defferent size
                children: [
                  Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
