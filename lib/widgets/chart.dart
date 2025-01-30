// widgets/chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expanse.dart';

class Chart extends StatelessWidget {
  final List<Expense> expenses;

  Chart(this.expenses);

  Map<Category, double> _getCategoryTotals() {
    final Map<Category, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return categoryTotals;
  }

  List<PieChartSectionData> _getPieChartSections() {
    final categoryTotals = _getCategoryTotals();
    final totalSpending =
        categoryTotals.values.fold(0.0, (sum, value) => sum + value);

    return categoryTotals.entries.map((entry) {
      final percentage = entry.value / totalSpending * 100;
      final color = _getCategoryColor(entry.key);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title:
            '${entry.key.toString().split('.').last}\n${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 32, 185, 193),
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.blue;
      case Category.travel:
        return Colors.green;
      case Category.leisure:
        return Colors.orange;
      case Category.work:
        return Colors.red;
      default:
        return const Color.fromARGB(255, 180, 79, 79);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Spending by Category',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2, // Add spacing between sections
                  borderData: FlBorderData(show: false),
                  // Remove the border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
