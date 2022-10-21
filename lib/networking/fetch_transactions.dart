import 'dart:convert';

import 'package:client/models/transaction_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<List<Transaction>> fetchTransactions({required String userId}) async {
  try {
    var res =
        await http.get(Uri.parse("$baseUrl/api/transactions?userId=$userId"));

    var fetchedTransactions = jsonDecode(res.body);

    List<Transaction> transactions = fetchedTransactions
        .map<Transaction>((transaction) => Transaction(
              amount: transaction["amount"].toDouble(),
              type: transaction["type"],
              createdAt: DateTime.parse(transaction["createdAt"]),
              status: transaction["status"],
              id: transaction["_id"],
            ))
        .toList();

    return transactions;
  } catch (e) {
    rethrow;
  }
}
