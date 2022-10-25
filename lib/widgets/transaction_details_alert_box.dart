import 'package:client/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../networking/delete_transaction.dart';
import '../store/transaction_data.dart';
import '../utils/date_to_text.dart';

class TransactionDetailsAlertBox extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsAlertBox({
    super.key,
    required this.transaction,
  });

  void deleteTransactionHandler(BuildContext context) async {
    var navigator = Navigator.of(context);
    var transactionsSlice =
        Provider.of<TransactionsData>(context, listen: false);

    await deleteTransactionOnServer(id: transaction.id);

    transactionsSlice.deleteTransaction(transaction.id);
    navigator.pop();
  }

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
