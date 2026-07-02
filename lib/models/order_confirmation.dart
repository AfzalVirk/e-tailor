class OrderConfirmation {
  final String orderNo;
  final double total;
  final DateTime dateTime;
  final String paymentMethod;
  final String name;
  final String email;

  const OrderConfirmation({
    required this.orderNo,
    required this.total,
    required this.dateTime,
    required this.paymentMethod,
    required this.name,
    required this.email,
  });
}
