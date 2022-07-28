import 'dart:math';

import 'package:costs_manager/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final Function deleteTx;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late final Color _bgColor;

  final List<Color> _bgColors = [
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    _bgColor = _bgColors[Random().nextInt(_bgColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _bgColor,
            radius: 30,
            child: FittedBox(
              child: Text(
                '\$${widget.transaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(widget.transaction.date),
            style: const TextStyle(color: Colors.grey),
          ),
          // ?NOTE: different widgets shows depend on different device size
          trailing: MediaQuery.of(context).size.width > 460
              ? TextButton.icon(
                  label: const Text("Delete"),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    widget.deleteTx(widget.transaction.id);
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    widget.deleteTx(widget.transaction.id);
                  },
                ),
        ),
      ),
    );
  }
}
