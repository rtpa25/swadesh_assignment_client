import 'package:client/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../utils/date_to_text.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
