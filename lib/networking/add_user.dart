import 'dart:convert';

import 'package:client/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<User> createUserOnServer({required String uuid}) async {
  try {
    var res = await http.post(Uri.parse("$baseUrl/api/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uuid': uuid,
        }));

    User user = User(
      balance: jsonDecode(res.body)["balance"].toDouble(),
      id: jsonDecode(res.body)["_id"],
      uuid: jsonDecode(res.body)["uuid"],
    );

    return user;
  } catch (e) {
    rethrow;
  }
}
