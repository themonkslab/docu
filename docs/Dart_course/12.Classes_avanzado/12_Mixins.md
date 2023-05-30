---
sidebar_position: 12
title: 12. Mixins
---

# Mixins

@Mau Di Bert

Quiero que vayan al paquete que habíamos creado llamado `abstract_classes_exercise`.

Allí, dentro de `abstract_classes_exercise_base.dart`, teníamos una clase abstracta `PaymentType` y luego varias clases que lo extendían, implementando cada una el método `processPayment`. Este método, se encargaba de imprimir la cantidad pagada y el email o la cuenta de banco, dependiendo el caso.

Si bien era un simple ejemplo, le faltaba algo fundamental: cuando ese método corría e imprimía en consola, en ningún lugar quedaba impresa la información sobre el momento en que dicho pago fue realizado.

Una forma podría ser entrar a cada uno de sus métodos y hacer algo así:

```dart
class CashPayment extends PaymentType {
  CashPayment({
    required super.id,
    required super.amount,
  });

  @override
  String processPayment() {
    print('${DateTime.now()} || Paid amount: $amount');
    return 'CashPayment';
  }
}
```

Lo anterior requeriría que cambiemos esto en cada una de las implementaciones siendo pocas en nuestro ejemplo pero imaginen en un ejemplo mucho mayor! Tenemos otra alternativa: utilizar _mixins_.

__Los _mixins_ son clases que no pueden ser instanciadas y se utilizan para agregar funcionalidad a otra clase.__ Además, no existe un número limitado de _mixins_ que podamos agregar a una clase.

En el caso en cuestión, podríamos definir el siguiente _mixin_:

```dart
mixin TimeLogging {
  void log(String message) {
    print('${DateTime.now()} || $message');
  }
}
```

Aquí lo que hicimos es en lugar de utilizar la palabra `class`, utilizar la palabra `mixin` y luego definir nuestro comportamiento como nombre del _mixin_. Dentro de él, creamos el método `log` que recibe un `message` e imprime lo que le pasemos agregando al comienzo el momento en el que dicha transacción fue realizada.

Para utilizarlo, simplemente tenemos que agregar la palabra `with` a la clase y emplear su método:

```dart
abstract class PaymentType {
  PaymentType({
    required this.id,
    required this.amount,
  });

  int id;
  double amount;

  String processPayment();
}

mixin TimeLogging {
  void log(String message) {
    print('${DateTime.now()} || $message');
  }
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

class PayPalPayment extends PaymentType with TimeLogging {
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
```

Lo único que tuvimos que hacer fue cambiar nuestro `print` por `log` y vean lo que sucede cuando corren el ejemplo:

```shell
2023-03-22 08:22:04.169403 || Paid amount: 1000.0
This transaction was processed by CashPayment
2023-03-22 08:22:04.171223 || Paid amount: 1500.0 to test@gmail.com
This transaction was processed by PayPalPayment
2023-03-22 08:22:04.171430 || Paid amount: 2500.0 to 123456789
This transaction was processed by BankTransactionPayment
Exited
```

Pueden probar por ustedes mismos qué pasa si intentan hacer lo siguiente:

```dart
  final timeLogging = TimeLogging();
```

Tenemos un error que dice _Mixins can't be instantiated_, diciéndonos que no pueden ser instanciados.

Podríamos haber en su lugar una clase abstracta?

## Mixins vs Abstract classes

Las clases abstractas y los mixins comparten similitudes en el sentido de que ambos pueden definir métodos y propiedades que se implementan en otras clases. Sin embargo, las __clases abstractas se utilizan para definir una "plantilla" para otras clases que deben implementar todos los métodos y propiedades definidos en la clase abstracta, mientras que los mixins se utilizan para agregar funcionalidad a una clase sin tener que extenderla.__

En general, se recomienda utilizar una clase abstracta cuando se desea definir una estructura básica que se implementará en varias clases relacionadas y los mixins para agregar funcionalidades a dichas clases.

## Utilizando más de un mixin

Para seguir completando nuestro sistema, queremos ahora poder definir algunos tipos de pagos, como reembolsables (_refundables_). Podríamos ir a nuestra clase abstracta y definir un `bool` que nos diga si es o no reembolsable:

```dart
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
```

Luego en nuestra `Transaction`, chequear si dicho método es reembolsable e imprimir algo:

```dart
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
      print('This payment is refundable');
    }
    print('This transaction was processed by $type');
  }
}
```

Y por ejemplo en una de nuestras clases, sobreescribir la clase abstracta para hacer esta subclase, reembolsable:

```dart
class PayPalPayment extends PaymentType with TimeLogging {
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

  @override
  bool isRefundable() => true;
}
```

Esto funciona aunque nos obliga a sobreescribir en cada clase el `bool`. Si creáramos en lugar de esto otro _mixin_ llamado `Refundable` que se encargue él mismo de sobreescribir dicho `bool` e imprimir:

```dart
mixin Refundable {
  void refund() {
    print('This payment is refundable');
  }

  bool isRefundable() => true;
}
```

Luego podríamos extenderlo en nuestra clase:

```dart
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
```

Para aplicarlo en nuestra `Transaction` y poder utilizarlo!

```dart
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
```

Noten que en este caso, tenemos que chequear si dicho `paymentType` es reembolsable y luego aclararle a Dart para que sepa que se trata de un tipo reembolsable y así poder llamar a su método.

## Name collisions

Qué creen que se imprimiría en el siguiente ejemplo?

```dart
mixin Mixin1 {
  int foo = 1;
}

mixin Mixin2 {
  int foo = 2;
}

class Foo with Mixin1, Mixin2 {
  void printFoo() => print(foo);
}

void main() {
  final foo = Foo();
  foo.printFoo();
}
```

Lo que imprime la consola es 2! Esto significa que podemos acceder a la variable `foo` de `Mixin2` pero no a `foo` de `Mixin1`. En este caso parece obvio el problema y puede ser simplemente solucionable pero imaginen en proyectos mucho más grandes y complejos? Tenemos que tener mucho cuidado ya que Dart no nos puede proteger en estos casos.

En resúmen:

- Quédense con los _mixin_ para agregar comportamiento y utilicen las clases abstractas para definir modelos que tienen que ser extendidos o implementados. Utilizarlos de forma combinada nos permite tener una jerarquía menos profunda de clases lo que llevará a un manejo más sencillo de nuesta aplicación.
- Cuiden mucho en dónde lo utilizan y presten particular atención a cómo los llaman. Siempre piensen en escribir código que sea simple de mantener, que si tienen que hacer cambios en el futuro, no tengan que hacerlo en toda la aplicación o escribir como ya dijimos varias veces, código defensivo, dificultando el que podamos cometer errores.
