import 'package:flutter/material.dart';
import 'package:tracker/widgets/chart.dart';
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
  final List<Expense> _registeredexpenses = [
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
        context: context,
        isScrollControlled: true,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredexpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredexpenses.indexOf(expense);
    setState(() {
      _registeredexpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredexpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
    ();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('no expenses found. Start adding some!'),
    );
    if (_registeredexpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredexpenses,
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
      body: Column(children: [
        Chart(expenses: _registeredexpenses),
        Expanded(child: mainContent),
      ]),
    );
  }
}
