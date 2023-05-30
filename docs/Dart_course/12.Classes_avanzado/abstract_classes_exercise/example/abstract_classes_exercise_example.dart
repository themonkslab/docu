import 'package:abstract_classes_exercise/src/abstract_classes_exercise_base.dart';

void main() {
  final transaction1 = Transaction(
    id: 1,
    fullName: 'John Doe',
    paymentType: CashPayment(id: 1, amount: 1000.0),
  );

  final transaction2 = Transaction(
      id: 2,
      fullName: 'Jane Doe',
      paymentType:
          PayPalPayment(id: 2, amount: 1500.0, email: 'test@gmail.com'));

  transaction1.processTransaction();
  transaction2.processTransaction();

  /// No tenemos que modificar la clase Transaction para poder agregar un nuevo
  /// tipo de pago, ya que dicha clase recibe un objeto de tipo PaymentType e
  /// interactúa con sus métodos; la implementación de los métodos de
  /// PaymentType es responsabilidad de las clases que heredan de PaymentType.
  final transaction3 = Transaction(
      id: 3,
      fullName: 'June Doe',
      paymentType: BankTransactionPayment(
          id: 3, amount: 2500.0, bankAccount: '123456789'));

  transaction3.processTransaction();
}
