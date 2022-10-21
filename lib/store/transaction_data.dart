import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionsData extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions = [transaction, ..._transactions];
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }
}
