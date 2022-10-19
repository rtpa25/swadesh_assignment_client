import 'dart:convert';

import 'package:client/models/transaction_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<Transaction> createTransactionOnServer({
  required String userId,
  required String transactionAmount,
  required String transactionType,
}) async {
  var res = await http.post(Uri.parse("$baseUrl/api/transactions"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': transactionAmount,
        'type': transactionType,
        'user': userId,
        'status': "created",
      }));

  Transaction newTransaction = Transaction(
    amount: jsonDecode(res.body)["amount"].toDouble(),
    type: jsonDecode(res.body)["type"],
    createdAt: DateTime.parse(jsonDecode(res.body)["createdAt"]),
    status: jsonDecode(res.body)["status"],
  );
  return newTransaction;
}
