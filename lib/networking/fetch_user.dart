import 'dart:convert';

import 'package:client/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future<User> fetchUser({
  required String uuid,
}) async {
  try {
    var res = await http.get(Uri.parse("$baseUrl/api/users?uuid=$uuid"));
    User user = User(
      balance: jsonDecode(res.body)["balance"].toDouble(),
      id: jsonDecode(res.body)["_id"],
      uuid: uuid,
    );
    return user;
  } catch (e) {
    rethrow;
  }
}
