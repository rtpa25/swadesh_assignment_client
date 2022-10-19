import 'package:client/store/transaction_data.dart';
import 'package:client/store/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../networking/fetch_transactions.dart';
import 'transaction_tile.dart';

class TransactionsList extends StatelessWidget {
  final Function updateTransactionLoadingFlag;
  const TransactionsList({Key? key, required this.updateTransactionLoadingFlag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final String? userId = Provider.of<UserData>(context, listen: false).id;
        final transactionsSlice =
            Provider.of<TransactionsData>(context, listen: false);

        updateTransactionLoadingFlag(true);

        List<Transaction> transactions =
            await fetchTransactions(userId: userId!);

        transactionsSlice.setTransactions(transactions);
        updateTransactionLoadingFlag(false);
      },
      child: ListView.builder(
        itemCount: Provider.of<TransactionsData>(context).transactions.length,
        itemBuilder: (context, index) {
          return TransactionTile(
            transaction:
                Provider.of<TransactionsData>(context).transactions[index],
          );
        },
      ),
    );
  }
}
