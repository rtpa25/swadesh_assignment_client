import 'package:client/store/transaction_data.dart';
import 'package:client/store/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../networking/fetch_transactions.dart';
import 'transaction_tile.dart';

class TransactionsList extends StatelessWidget {
  final Function updateTransactionLoadingFlag;
  final String sortingCriteria;
  final String filterCriteria;
  const TransactionsList({
    Key? key,
    required this.updateTransactionLoadingFlag,
    required this.sortingCriteria,
    required this.filterCriteria,
  }) : super(key: key);

  Future<void> refreshTransactionsListHandler(BuildContext context) async {
    final String? userId = Provider.of<UserData>(context, listen: false).id;
    final transactionsSlice =
        Provider.of<TransactionsData>(context, listen: false);

    updateTransactionLoadingFlag(true);

    List<Transaction> transactions = await fetchTransactions(
      userId: userId!,
      filter: filterCriteria,
      sort: sortingCriteria,
    );

    transactionsSlice.setTransactions(transactions);
    updateTransactionLoadingFlag(false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshTransactionsListHandler(context);
      },
      child: Provider.of<TransactionsData>(context).transactions.isNotEmpty
          ? ListView.builder(
              itemCount:
                  Provider.of<TransactionsData>(context).transactions.length,
              itemBuilder: (context, index) {
                return TransactionTile(
                  transaction: Provider.of<TransactionsData>(context)
                      .transactions[index],
                );
              },
            )
          : const Center(
              child: Text(
                'Hit the plus button to add a transaction',
              ),
            ),
    );
  }
}
