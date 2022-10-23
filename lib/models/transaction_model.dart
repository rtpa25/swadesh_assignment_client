class Transaction {
  double amount;
  String type;
  DateTime createdAt;
  String status;
  String id;
  String senderId;
  String receiverId;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.senderId,
    required this.receiverId,
  });
}
