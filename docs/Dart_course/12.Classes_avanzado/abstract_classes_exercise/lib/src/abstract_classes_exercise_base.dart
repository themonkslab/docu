abstract class PaymentType {
  PaymentType({
    required this.id,
    required this.amount,
  });

  int id;
  double amount;

  String processPayment();

  bool isRefundable() => false;
}

mixin TimeLogging {
  void log(String message) {
    print('${DateTime.now()} || $message');
  }
}

mixin Refundable {
  void refund() {
    print('This payment is refundable');
  }

  bool isRefundable() => true;
}

class CashPayment extends PaymentType with TimeLogging {
  CashPayment({
    required super.id,
    required super.amount,
  });

  @override
  String processPayment() {
    log('Paid amount: $amount');
    return 'CashPayment';
  }
}

class PayPalPayment extends PaymentType with TimeLogging, Refundable {
  PayPalPayment({
    required super.id,
    required super.amount,
    required this.email,
  });

  String email;

  @override
  String processPayment() {
    log('Paid amount: $amount to $email');
    return 'PayPalPayment';
  }
}

class Transaction {
  Transaction({
    required this.id,
    required this.fullName,
    required this.paymentType,
  });

  int id;
  String fullName;
  PaymentType paymentType;

  void processTransaction() {
    var type = paymentType.processPayment();
    if (paymentType.isRefundable()) {
      (paymentType as Refundable).refund();
    }
    print('This transaction was processed by $type');
  }
}

class BankTransactionPayment extends PaymentType with TimeLogging {
  BankTransactionPayment({
    required super.id,
    required super.amount,
    required this.bankAccount,
  });

  String bankAccount;

  @override
  String processPayment() {
    log('Paid amount: $amount to $bankAccount');
    return 'BankTransactionPayment';
  }
}
