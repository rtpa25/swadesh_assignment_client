import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<void> deleteTransactionOnServer({required String id}) async {
  await http.delete(
    Uri.parse("$baseUrl/api/transactions"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{"id": id}),
  );
}
