import 'package:client/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../utils/date_to_text.dart';

class TransactionDetailsAlertBox extends StatelessWidget {
  final Transaction transaction;
  final Function(BuildContext context) deleteTransactionHandler;

  const TransactionDetailsAlertBox(
      {super.key,
      required this.transaction,
      required this.deleteTransactionHandler});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transaction Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Amount:'),
              Text(transaction.amount.toString()),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Date:'),
              Text(dateToTextConvertor(transaction.createdAt)),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                deleteTransactionHandler(context);
              },
              child: const Text('DELETE'),
            ),
          ],
        ),
      ],
    );
  }
}
