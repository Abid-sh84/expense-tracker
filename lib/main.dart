import 'package:flutter/material.dart';
import 'models/expanse.dart';
import 'widgets/expanse_list.dart';
import 'widgets/new_expanse.dart';
import 'widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseTracker(),
    );
  }
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _expenses = [];

  void _addExpense(
      String title, double amount, DateTime date, Category category) {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
      category: category,
    );

    setState(() {
      _expenses.add(newExpense);
    });
  }

  void _startAddExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewExpense(_addExpense);
      },
    );
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddExpense(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(_expenses),
          Expanded(
            child: ExpenseList(_expenses, _deleteExpense),
          ),
        ],
      ),
    );
  }
}
