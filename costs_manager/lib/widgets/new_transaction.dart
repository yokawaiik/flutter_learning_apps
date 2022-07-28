import 'dart:io';

import 'package:costs_manager/utils/isNumber.dart';
import 'package:costs_manager/widgets/adaptive_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  late final TextEditingController _titleEditingController;
  late final TextEditingController _amountEditingController;

  DateTime? _pickedDate;

  @override
  void initState() {
    _titleEditingController = TextEditingController();
    _amountEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _amountEditingController.dispose();
    _pickedDate = DateTime.now();
    super.dispose();
  }

  void _submitData() {
    // data checks
    final String enteredTitle = _titleEditingController.text;
    late final double enteredAmount;
    if (!isNumber(_amountEditingController.text)) {
      return;
    }
    if (enteredTitle.isEmpty || _pickedDate == null) {
      return;
    }
    enteredAmount = double.parse(_amountEditingController.text);

    // next handler in parent widget
    widget.addTx(enteredTitle, enteredAmount, _pickedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      print(pickedData);
      if (pickedData == null) return;
      setState(() {
        _pickedDate = pickedData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    // final isIos = Platform.isAndroid;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isIos) ...[
            CupertinoTextField(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              placeholder: "Title",
              controller: _titleEditingController,
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              placeholder: "Amount",
              controller: _amountEditingController,
              onSubmitted: (_) => _submitData(),
            )
          ] else ...[
            TextField(
              controller: _titleEditingController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountEditingController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            )
          ],
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _pickedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(_pickedDate!)}',
                  ),
                ),
                AdaptiveButton(text: "Choose Date", handlerFunction: _presentDatePicker)
              ],
            ),
          ),

            AdaptiveButton(text: "Add transaction", handlerWithoutArguments: _submitData)
        ],
      ),
    );
  }
}
