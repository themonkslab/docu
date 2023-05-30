---
sidebar_position: 6
title: 6. Extends and implements
---

# Extends and implements

@Mau Di Bert

Dupliquen el ejercicio anterior y póngale el nombre `implement_extends`. Renombren todo y no se olviden de correr el `dart pub get`.

Vamos al archivo ahora llamado `implement_extends_base.dart` y quiero que prueben hacer algo: implementen (definan un cuerpo) en la función `processPayment()` de la clase abstracta `PaymentType`. Por ejemplo:

```dart
abstract class PaymentType {
  PaymentType({
    required this.id,
    required this.amount,
  });

  int id;
  double amount;

  // String processPayment();
  String processPayment() => 'This is an implementation of PaymentType';
}
```

Pueden ver ahora que si eliminan de las subclases que la extienden la sobreescritura de dicho método, no vamos a tener errores. Por ejemplo:

```dart
class CashPayment extends PaymentType {
  CashPayment({
    required super.id,
    required super.amount,
  });

  // @override
  // String processPayment() {
  //   print('Paid amount: $amount');
  //   return 'CashPayment';
  // }
}
```

Esto es porque ahora tenemos una clase abstracta llamada `PaymentType` pero __`processPayment()` no es abstracto sino concreto, existe una implementación de dicho método.__

También esta clase abstracta podría tener métodos privados. Por ejemplo:

```dart
abstract class PaymentType {
  PaymentType({
    required this.id,
    required this.amount,
  });

  int id;
  double amount;

  String processPayment();
  void _declareId() => print('Id: $id');
}

class CashPayment extends PaymentType {
  CashPayment({
    required super.id,
    required super.amount,
  });

  @override
  String processPayment() {
    print('Paid amount: $amount');
    super._declareId();
    return 'CashPayment';
  }
}
```

Esto sucede solamente en clases abstractas. Pero  __cómo hacemos nosotros si lo que queremos es forzar a cada subclase que implemente los métodos que definimos en nuestra clase abstracta? Tenemos que volver a dicha clase, una `Interface`__ que es muy parecida a la anterior, solo que en nuestra interfaz vamos a obligar a implementar sus métodos.

__Las interfaces son clases abstractas que definen métodos también abstractos y deben ser implementados por las clases que las implementan__. Además las interfaces __no pueden tener constructores__ por lo que la nuestra se vería algo así:

```dart
abstract class PaymentType {
  String processPayment();
}
```

Y qué pasó con los campos o _fields_? __Las interfaces tampoco pueden tener propiedades aunque podrían sí tener _getters_ y _setters_ que cumplan una función parecida__:

```dart
abstract class PaymentType {
  int get id;
  double get amount;
  String processPayment();
}
```

Nuestra `Interface` ahora puede ser implementada, solamente __cambiando `extends` por `implements`__ en nuestra clase hija. 💀 Les muestro un ejemplo y vayan a corregir los restantes:

```dart
class CashPayment implements PaymentType {
  CashPayment({
    required this.id,
    required this.amount,
  });

  @override
  final int id;
  @override
  final double amount;

  @override
  String processPayment() {
    print('Paid amount: $amount');
    return 'CashPayment';
  }
}
```

El resto:

```dart
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
```

Probaron correr los tests? Vieron que todos corren a la perfección confirmando que __cada subclase implementa a su clase padre cumpliendo con el contrato que ella determinó__?

__Quiero hacer un _stop_ para que guardemos este concepto: contrato.__ Qué sería un contrato o _contract_? __Es un acuerdo entre partes__. En este caso el acuerdo se desarrolla entre una clase padre que requiere el cumplimiento de ciertos métodos y una subclase hija diciendo que los va a cumplir. __Si se trata de una _interface_ o interfaz, la implementación de cada método es obligatoria; si se trata de una clase abstracta, la implementación de los métodos abstractos es obligatoria mientras que de los métodos concretos no.__

## Implementando varias interfaces

En Argentina es muy común aun que cuando vayamos a pagar en efectivo a algún lugar, nos pregunten si queremos una factura, lo que sería un comprobante para el gobierno de que la venta fue efectuada. Los vendedores evitan hacerla para así no pagar impuestos sobre dicha venta.

La representación de ese proceso no sería enteramente correcto el representarlo dentro de `PaymentType` sino más bien como un `PaymentExtra` quizás, una nueva clase abstracta que también implementemos:

```dart
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
```

```shell
Paid amount: 1000.0. Taxable: false
This transaction was processed by CashPayment
```

Aquí podemos ver que nuestra clase `CashPayment` puede implementar más de una _interface_, cosa que no podría hacer utilizando _extends_. Por otro lado, no sería para nada aplicable esta _interface_ a las clases `PayPalPayment` y `BankTransactionPayment` ya que los vendedores no tienen forma de evitar el pago de impuestos en dichas operaciones. En este caso, __podemos ver cómo vamos separando en módulos a nuestro código, lo que nos permite no tener que modificar en nada la clases que interactúan con nuestra clase padre.__

💀 Solo quedaría hacer una actualización de nuestros tests. Les dejo el archivo entero para que no se pierdan:

```dart
import 'package:implement_extends/implement_extends.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CashPayment class', () {
    late CashPayment paymentType;
    setUp(() {
      paymentType = CashPayment(id: 1, amount: 1000.0, isTaxable: false);
    });

    test(
        'When I create a CashPayment, Then I get a PaymentType and a CashPayment with a `int` id and a `double` amount',
        () {
      expect(paymentType, isA<PaymentType>());
      expect(paymentType, isA<CashPayment>());
      expect(paymentType.id, isA<int>());
      expect(paymentType.amount, isA<double>());
      expect(paymentType.isTaxable, isA<bool>());
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
        paymentType: CashPayment(id: 1, amount: 1000.0, isTaxable: false),
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
```

## Síntesis

En Dart, una clase abstracta es similar a una interfaz en que ambas definen una serie de métodos y propiedades que deben ser implementados por las clases que las extienden o implementan. Sin embargo, hay algunas diferencias importantes entre ambas.

Una clase abstracta puede tener métodos y propiedades que tienen una implementación por defecto, mientras que en una interfaz todos los métodos son abstractos y deben ser implementados por la clase que la implementa y las propiedades deben implementarse mediante _setters_ y _getters_.

Por otro lado, una subclase puede extender solamente una clase abstracta mientras que puede implementar varias interfaces.

Además, una clase abstracta puede tener constructores, mientras que una interfaz no puede tenerlos. Las clases abstractas también pueden tener métodos que no son públicos, lo que significa que sólo pueden ser utilizados por las subclases de la clase abstracta.

En resumen, las clases abstractas son más flexibles que las interfaces ya que permiten tener implementaciones por defecto de algunos métodos y también pueden tener constructores y métodos privados, mientras que las interfaces sólo pueden definir una serie de métodos abstractos que deben ser implementados por la clase que la implementa.
