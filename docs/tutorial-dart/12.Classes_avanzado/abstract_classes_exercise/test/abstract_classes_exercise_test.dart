import 'package:abstract_classes_exercise/src/abstract_classes_exercise_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CashPayment class', () {
    late CashPayment paymentType;
    setUp(() {
      paymentType = CashPayment(id: 1, amount: 1000.0);
    });

    test(
        'When I create a CashPayment, Then I get a PaymentType and a CashPayment with a `int` id and a `double` amount',
        () {
      expect(paymentType, isA<PaymentType>());
      expect(paymentType, isA<CashPayment>());
      expect(paymentType.id, isA<int>());
      expect(paymentType.amount, isA<double>());
    });

    test(
        'When I call processPayment, Then I get a String that says "CashPayment"',
        () {
      expect(paymentType.processPayment(), isA<String>());
      expect(paymentType.processPayment(), "CashPayment");
    });
  });

  group('Given a PayPalPayment class', () {
    late PayPalPayment paymentType;
    setUp(() {
      paymentType =
          PayPalPayment(id: 2, amount: 1500.0, email: 'test@gmail.com');
    });

    test(
        'When I create a CashPayment, Then I get a PaymentType and a PayPalPayment with a `int` id, a `double` amount and a `String` email',
        () {
      expect(paymentType, isA<PaymentType>());
      expect(paymentType, isA<PayPalPayment>());
      expect(paymentType.id, isA<int>());
      expect(paymentType.amount, isA<double>());
      expect(paymentType.email, isA<String>());
    });

    test(
        'When I call processPayment, Then I get a String that says "PayPalPayment"',
        () {
      expect(paymentType.processPayment(), isA<String>());
      expect(paymentType.processPayment(), "PayPalPayment");
    });
  });

  group('Given a Transaction class', () {
    late Transaction transaction;
    setUp(() {
      transaction = Transaction(
        id: 1,
        fullName: 'John Doe',
        paymentType: CashPayment(id: 1, amount: 1000.0),
      );
    });

    test('When I create a Transaction, Then I get a Transaction', () {
      expect(transaction, isA<Transaction>());
    });

    test('When I call processPayment, Then I get a Function', () {
      expect(transaction.processTransaction, isA<Function>());
    });
  });

  group('Given a BankTransactionPayment', () {
    late BankTransactionPayment paymentType;
    setUp(() {
      paymentType = BankTransactionPayment(
        id: 3,
        amount: 2000.0,
        bankAccount: '123456789',
      );
    });

    test(
        'When I create a BankTransactionPayment, Then I get a PaymentType and a BankTransactionPayment with a `int` id, a `double` amount and a `String` bankAccount',
        () {
      expect(paymentType, isA<PaymentType>());
      expect(paymentType, isA<BankTransactionPayment>());
      expect(paymentType.id, isA<int>());
      expect(paymentType.amount, isA<double>());
      expect(paymentType.bankAccount, isA<String>());
    });

    test(
        'When I call processPayment, Then I get a String that says "BankTransactionPayment"',
        () {
      expect(paymentType.processPayment(), isA<String>());
      expect(paymentType.processPayment(), "BankTransactionPayment");
    });
  });
}
