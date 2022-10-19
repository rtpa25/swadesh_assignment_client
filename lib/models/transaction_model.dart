class Transaction {
  double amount;
  String type;
  DateTime createdAt;
  String status;

  Transaction({
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.status,
  });
}
