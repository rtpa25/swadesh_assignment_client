import 'dart:convert';

import 'package:client/models/transaction_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<Transaction> createTransactionOnServer({
  String? senderId,
  String? receiverId,
  required String transactionAmount,
  required String transactionType,
}) async {
  try {
    Map<String, String> body = {
      "amount": transactionAmount,
      "type": transactionType,
    };

    if (senderId != null && receiverId != null) {
      body = {
        "sender": senderId,
        "receiver": receiverId,
        ...body,
      };
    } else if (senderId != null && receiverId == null) {
      body = {
        "sender": senderId,
        ...body,
      };
    } else if (senderId == null && receiverId != null) {
      body = {
        "receiver": receiverId,
        ...body,
      };
    }

    var res = await http.post(
      Uri.parse("$baseUrl/api/transactions"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    Transaction newTransaction = Transaction(
      amount: jsonDecode(res.body)["amount"].toDouble(),
      type: jsonDecode(res.body)["type"],
      createdAt: DateTime.parse(jsonDecode(res.body)["createdAt"]),
      status: jsonDecode(res.body)["status"],
      id: jsonDecode(res.body)["_id"],
      receiverId: jsonDecode(res.body)["receiver"],
      senderId: jsonDecode(res.body)["sender"],
    );
    return newTransaction;
  } catch (e) {
    rethrow;
  }
}
