import 'package:client/models/transaction_model.dart';
import 'package:client/store/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/date_to_text.dart';
import 'transaction_details_alert_box.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    Color transactionAmountColor = transaction.type == "debit"
        ? Colors.red
        : (transaction.type == "credit"
            ? Colors.green
            : (transaction.senderId == Provider.of<UserData>(context).id
                ? Colors.red
                : Colors.green));

    return ListTile(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return TransactionDetailsAlertBox(
              transaction: transaction,
            );
          },
        );
      },
      leading: Text(
        "\$${transaction.amount}",
        style: TextStyle(
          fontSize: 18.0,
          color: transactionAmountColor,
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
