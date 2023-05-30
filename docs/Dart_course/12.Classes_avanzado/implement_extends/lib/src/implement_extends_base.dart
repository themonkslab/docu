abstract class PaymentType {
  int get id;
  double get amount;
  String processPayment();
}

abstract class PaymentExtras {
  bool get isTaxable;
}

class CashPayment implements PaymentType, PaymentExtras {
  CashPayment({
    required this.id,
    required this.amount,
    required this.isTaxable,
  });

  @override
  final int id;
  @override
  final double amount;
  @override
  final bool isTaxable;

  @override
  String processPayment() {
    print('Paid amount: $amount. Taxable: $isTaxable');
    return 'CashPayment';
  }
}

class PayPalPayment implements PaymentType {
  PayPalPayment({
    required this.id,
    required this.amount,
    required this.email,
  });

  @override
  double amount;
  @override
  int id;
  String email;

  @override
  String processPayment() {
    print('Paid amount: $amount to $email');
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
    final type = paymentType.processPayment();
    print('This transaction was processed by $type');
  }
}

class BankTransactionPayment implements PaymentType {
  BankTransactionPayment({
    required this.id,
    required this.amount,
    required this.bankAccount,
  });

  @override
  double amount;
  @override
  int id;
  String bankAccount;

  @override
  String processPayment() {
    print('Paid amount: $amount to $bankAccount');
    return 'BankTransactionPayment';
  }
}
