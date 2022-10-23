import 'dart:convert';

import 'package:client/models/transaction_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<List<Transaction>> fetchTransactions({
  required String userId,
  String? sort,
  String? filter,
}) async {
  try {
    http.Response res;

    if (sort != null && filter == null) {
      res = await http.get(
          Uri.parse("$baseUrl/api/transactions?userId=$userId&sort=$sort"));
    } else if (filter != null && sort == null) {
      res = await http.get(
          Uri.parse("$baseUrl/api/transactions?userId=$userId&filter=$filter"));
    } else if (filter != null && sort != null) {
      res = await http.get(Uri.parse(
          "$baseUrl/api/transactions?userId=$userId&sort=$sort&filter=$filter"));
    } else {
      res =
          await http.get(Uri.parse("$baseUrl/api/transactions?userId=$userId"));
    }

    var fetchedTransactions = jsonDecode(res.body);

    List<Transaction> transactions = fetchedTransactions
        .map<Transaction>((transaction) => Transaction(
              amount: transaction["amount"].toDouble(),
              type: transaction["type"],
              createdAt: DateTime.parse(transaction["createdAt"]),
              status: transaction["status"],
              id: transaction["_id"],
              receiverId: transaction["receiver"],
              senderId: transaction["sender"],
            ))
        .toList();

    return transactions;
  } catch (e) {
    rethrow;
  }
}
