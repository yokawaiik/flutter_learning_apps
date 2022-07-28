import 'package:costs_manager/models/transaction.dart';
import 'package:costs_manager/widgets/chart_bar.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(
        days: index,
      ));

      late double totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get _totalSpending {
    return _groupedTransactionValues.fold(0.0, (accumulator, item) {
      return accumulator + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      // elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          
          children: [
            ..._groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: data['day'] as String,
                  spendingAmount: (data['amount'] as double),
                  spendingPercentOfTotal: _totalSpending != 0.0 ?
                      ((data['amount'] as double) / _totalSpending) : 0.0,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
