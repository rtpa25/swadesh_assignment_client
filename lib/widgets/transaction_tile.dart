import 'package:client/models/transaction_model.dart';
import 'package:client/networking/delete_transaction.dart';
import 'package:client/store/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/date_to_text.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

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
    return ListTile(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
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
          },
        );
      },
      leading: Text(
        "\$${transaction.amount}",
        style: const TextStyle(
          fontSize: 18.0,
          color: Color(0xFFEB1555),
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textBaseline: TextBaseline.ideographic,
        children: <Widget>[
          Text(
            transaction.type,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            dateToTextConvertor(transaction.createdAt),
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
      trailing: Text(
        transaction.status,
        style: TextStyle(
          fontSize: 18.0,
          color: transaction.status == "pending"
              ? Colors.yellowAccent
              : (transaction.status == "success"
                  ? Colors.green
                  : const Color(0xFFEB1555)),
        ),
      ),
    );
  }
}
