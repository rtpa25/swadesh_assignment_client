import 'package:client/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  User? _user;

  int? get balance {
    if (_user != null) {
      return _user!.balance.toInt();
    }
    return null;
  }

  String? get uuid {
    if (_user != null) {
      return _user!.uuid;
    }
    return null;
  }

  String? get id {
    if (_user != null) {
      return _user!.id;
    }
    return null;
  }

  void setUserData(User user) {
    _user = user;
    notifyListeners();
  }
}
