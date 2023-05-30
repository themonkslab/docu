---
sidebar_position: 5
title: 5. Abstract classes
---

# Abstract classes

@Mau Di Bert

Vamos a crear un nuevo proyecto llamado `company_example` y vamos a borrar el contenido como ya lo hemos hecho en oportunidades anteriores.

Lo que quiero que hagamos es representar una empresa. Sin embargo, nos vamos a tomar un tiempo para escribir, pensar en los elementos mínimos que la van a constituir, representarla y finalmente, implementarlo.

## Planificación

Esta compañía que estamos imaginando tiene dos jerarquías: dueño (_Owner_) y empleado (_Employee_).

El dueño necesita obtener reportes de los empleados sobre el trabajo que realizan y dichos empleados querrán a su vez, obtener un aumento a medida que mejoran su rendimiento.

El dueño tendrá seguramente un nombre (_fullName_) y una función que le permita pedir reportes a sus empleados y medir con ellos su productividad (_measureProductivity_).

A su vez, vamos a tener dos tipos de empleados: el gerente (_manager_) y el ingeniero (_engineer_). Y cada uno de ellos va a tener un nombre (_fullName_), un identificador que nos permita determinar que es él y no otro empleado (_id_), un salario (_salary_), un método para reportar al dueño (_reportToOwner_) y un método para pedir aumento (_askForRaise_).

Ya que tenemos lo suficiente para entender las relaciones entre las partes de nuestra empresa, vamos a implementarla.

## Implementación

Vamos a empezar escribiendo los tests. Primero nos concentramos en el dueño: tiene que tener un nombre y un método aunque no sabemos bien qué tiene que hacer dicho método más allá de obtener un reporte de los empleados.

Por ahora vamos a implementar un test que nos ayude a crear un `Owner` con `fullName` y un método `measureProductivity` que tiene que recibir a la clase `Employee` para poder pedir el reporte y realizar un análisis de productividad; ustedes pueden ir adelantándose solitos! 💀

Por el momento, tendría algo así:

```dart
import 'package:test/test.dart';

void main() {
  group('Given an Ownwer', () {
    late Owner owner;
    setUp(() {
      owner = Owner(
          fullName: 'John Doe',
          measureProductivity: (Employee employee) => '';
  )});
    test('When I create an Owner, Then I get an Owner', () {
      expect(owner, isA<Owner>());
    });

    test(
        'When I create an Owner, Then I get an Owner with a fullName and a measureProductivity function',
        () {
      expect(owner.fullName, 'John Doe');
      expect(owner.measureProductivity, isA<Function>());
    });
  });
}
```

Por el momento, nuestro método `measureProductivity`, va a ser una función que retorne una `String` vacía ya que no sabemos bien qué hará y sí, luego cuando sepamos vamos a tener que volver a los tests y actualizarlo. Esta es una práctica muy común: __volver a los tests siempre para alinear sus objetivos iniciales con nuevos objetivos.__

Todo lo anterior, nos guía a qué tenemos que crear. Entonces en el `company_example_base.dart`, voy a crear dichas clases y las voy a importar a mi test para que deje de fallar:

```dart
class Owner {
  Owner({
    required this.fullName,
    required this.measureProductivity,
  });

  String fullName;
  String Function(Employee employee) measureProductivity;
}

class Employee {
  Employee({required this.reportToOwner});

  final String Function() reportToOwner;
}
```

Ahora, deberíamos correr el test sin ningún fallo. Y así sucede:

```shell
✓ Given an Ownwer When I create an Owner, Then I get an Owner
✓ Given an Ownwer When I create an Owner, Then I get an Owner with a fullName and a getReport function
Exited
```

Para poder arreglar nuestro test, tuvimos que crear además de la clase `Owner` una clase `Employee`. Sin embargo, no representa al tipo de empleado que imaginábamos, ya que nuestro empleado cuenta con otros campos. 💀 Les parece si la completan empezando por sus tests?

Voy yo:

```dart
 group('Given an Employee', () {
    late Employee employee;
    setUp(() {
      employee = Employee(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        reportToOwner: () => '',
        askForRaise: () => '',
      );
    });
    test('When I create an Employee, Then I get an Employee', () {
      expect(employee, isA<Employee>());
    });

    test(
        'When I create an Employee, Then I get an Employee with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(employee.fullName, 'John Doe');
      expect(employee.id, 1);
      expect(employee.salary, 1000);
      expect(employee.reportToOwner, isA<Function>());
      expect(employee.askForRaise, isA<Function>());
    });
  });
```

Ya tengo mi test y como pueden ver, está roto por todos lados! 🤣 Para poder arreglarlo, tenemos que completar nuestra clase `Employee`. Vamos a hacerlo:

```dart
class Employee {
  Employee({
    required this.fullName,
    required this.id,
    required this.salary,
    required this.askForRaise,
    required this.reportToOwner,
  });

  final String fullName;
  final int id;
  final double salary;
  final String Function() reportToOwner;
  final String Function() askForRaise;
}
```

Ya tenemos nuestra clase creada y ningún fallo cuando corremos nuestros tests. Noten que también aquí, creamos clases que retornen una `String` para `reportToOwner` y `askForRaise`.

__Recapitulando__: creamos una clase `Owner` y una `Employee` partiendo desde los tests. Nuestra empresa no obstante es pequeña y queremos que a cada tipo de empleado se le asigne un rol específico con tareas, características y posibilidades propias al rol, aunque cumpla con lo mínimo que determinamos que cada empleado debe tener: un nombre completo, un id, un salario, una posibilidad de pedir aumento y de elevar reportes.

A su vez, no sería nada práctico que puedan crearse empleados sin tener un rol y comportamientos específicos, lo que sería lo mismo que decir crear empleados utilizando la clase `Employee`. Por lo tanto, qué hacemos? Transformamos dicha clase en abstracta.

## Implementando la clase abstracta

La clase abstracta es __una clase que no puede ser instanciada directamente, sino que se usa como base para definir otras clases__. La idea detrás es que sirve como molde para otras clases que la extienden, que van a heredar sus características y funcionalidades.

La utilidad es que __permiten definir un conjunto común de características y comportamientos para una familia de clases relacionadas, sin la necesidad de implementarlos repetidamente en cada clase individual__. Por ejemplo, si se tiene un conjunto de objetos que comparten ciertas características y funcionalidades, se puede definir una clase abstracta para representar esas características comunes, y luego extender esa clase para crear otras clases que representen objetos específicos.

__Esta clase también puede definir métodos abstractos, que son métodos que no tienen una implementación en la clase__, sino que se implementan en las clases que la extienden. Esto permite definir un conjunto de métodos que deben ser implementados en cada subclase, asegurando que todas las subclases tengan un comportamiento consistente y predecible.

Vamos a hacerlo con nuestra clase `Employee`. Es muy sencillo:

1. agregar la _keyword_ `abstract` delante de la clase
2. definir sus funciones sin cuerpo: `valorDeRetorno Function() nombre()`
3. quitarlas del constructor

Observen cómo quedaría:

```dart
abstract class Employee {
  Employee({
    required this.fullName,
    required this.id,
    required this.salary,
  });

  final String fullName;
  final int id;
  final double salary;
  String Function() reportToOwner();
  String Function() askForRaise();
}
```

Podríamos limpiarla un poquito quitando el tipo en cada función ya que lo infiere cómodamente nuestro amado Dart:

```dart
abstract class Employee {
  Employee({
    required this.fullName,
    required this.id,
    required this.salary,
  });

  final String fullName;
  final int id;
  final double salary;
  String reportToOwner();
  String askForRaise();
}
```

Lo anterior, va a provocar errores en nuestro test, siendo el principal aquel que dice que una clase abstracta no puede ser instanciada: _'Abstract classes can't be instantiated. Try creating an instance of a concrete subtype'_. Y esto era exactamente lo que perseguíamos: que no se puedan crear empleados sin un rol!

Vamos a crear entonces una clase `Manager` que extienda de `Employee` y van a ver que apenas lo hacen, nos guía diciendo que tenemos que implementar sus métodos y un constructor:

```dart
class Manager extends Employee {}
```

Si se ayudan con `cmd + .`, esto es lo que va a crearles:

```dart
class Manager extends Employee {
  Manager({
    required super.fullName,
    required super.id,
    required super.salary,
  });

  @override
  Function() askForRaise() {
    // TODO: implement askForRaise
    throw UnimplementedError();
  }

  @override
  Function() reportToOwner() {
    // TODO: implement reportToOwner
    throw UnimplementedError();
  }
}
```

Observen que primero nos crea un constructor que utiliza `super.property` ya que al crearse nuestra clase `Manager` va a llamar al constructor de su clase padre (ahora una clase abstracta) y va a pasarle los argumentos que reciba.

Por otro lado, nos pide implementar los métodos `reportToOwner` y `askForRaise`, nos crea dichos métodos solo que lanzan errores. Además, se encarga de crearnos un `// TODO`, un comentario que refiere a una tarea que tenemos que realizar.

De esta forma, podríamos cambiar nuestro test ya no para testear la clase abstracta sino la implementación concreta de nuestro `Manager`. Se animan a probarlo ustedes? 💀

```dart
group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
      );
    });
    test('When I create a Manager, Then I get a Manager', () {
      expect(manager, isA<Employee>());
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.reportToOwner, isA<Function>());
      expect(manager.askForRaise, isA<Function>());
    });
  });
```

Y pudieron observar algo en el código anterior? La verdad es que no lo hice a propósito pero ahora sí lo haré:

```dart
group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
      );
    });
    test(
        // 👁️
        'When I create a Manager, Then I get a Manager that extends the abstract class Employee',
        () {
      expect(manager, isA<Manager>());
      expect(manager, isA<Employee>()); // 👁️
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.reportToOwner, isA<Function>());
      expect(manager.askForRaise, isA<Function>());
    });
  });
```

Podemos observar aquí que un `Manager` es un `Manager` (😋) pero también un `Employee`. Y podríamos completar la clase escribiendo algo así en sus métodos:

```dart
class Manager extends Employee {
  Manager({
    required super.fullName,
    required super.id,
    required super.salary,
  });

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  String reportToOwner() => 'I am a Manager and I\'ve managed this an that';
}
```

Y actualizar claramente, nuestros tests:

```dart
  group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
      );
    });
    test(
        'When I create a Manager, Then I get a Manager that extends an Employee',
        () {
      expect(manager, isA<Manager>());
      expect(manager, isA<Employee>());
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.reportToOwner, isA<Function>());
      expect(manager.askForRaise, isA<Function>());
    });

    test(
        'When I call the reportToOwner function, Then I get a String with the report',
        () {
      expect(manager.reportToOwner(),
          'I am a Manager and I\'ve managed this an that');
    });

    test(
        'When I call the askForRaise function, Then I get a String with the request',
        () {
      expect(manager.askForRaise(), 'I am asking for a raise');
    });
  });
  ```

Tienen todo lo necesario para salir corriendo e implementar la clase `Engineer`!
💀
Primero sus tests:

```dart
  group('Given an Engineer', () {
    late Engineer engineer;
    setUp(() {
      engineer = Engineer(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
      );
    });
    test(
        'When I create a Engineer, Then I get a Engineer that extends an Employee',
        () {
      expect(engineer, isA<Engineer>());
      expect(engineer, isA<Employee>());
    });

    test(
        'When I create a Engineer, Then I get a Engineer with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(engineer.fullName, 'John Doe');
      expect(engineer.id, 1);
      expect(engineer.salary, 1000);
      expect(engineer.reportToOwner, isA<Function>());
      expect(engineer.askForRaise, isA<Function>());
    });

    test(
        'When I call the reportToOwner function, Then I get a String with the report',
        () {
      expect(engineer.reportToOwner(),
          'I am an Engineer and I\'ve engineered this an that');
    });

    test(
        'When I call the askForRaise function, Then I get a String with the request',
        () {
      expect(engineer.askForRaise(), 'I am asking for a raise');
    });
  });
  ```

  Y luego la implementación de la clase:

  ```dart
  class Engineer extends Employee {
  Engineer({
    required super.fullName,
    required super.id,
    required super.salary,
  });

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  String reportToOwner() =>
      'I am an Engineer and I\'ve engineered this an that';
}
```

Cómo se van sintiendo con este procedimiento? __Personalmente, me da mucha seguridad el repetir el siguiente proceso de forma cíclica:__

1. Escribir qué entiendo del problema y qué
2. Explicárselo a alguien más así sea un 'patito de goma'*
3. Escribir los casos de uso de los tests siguiendo la convención _Given_, _Then_, _When_.
4. Implementar los tests.
5. Implementar lo que resuelva dichos tests.

*La práctica de explicar algo que acabamos de estudiar a un patito de goma es una técnica conocida como "pato de goma" o _rubber duck_ en inglés. Se utiliza para ayudar a solucionar problemas o para comprender mejor un concepto.

La idea detrás es que al explicar un problema o un concepto a un pato de goma, nos obligamos a hablar en voz alta y a organizar tus pensamientos de una manera clara y concisa. Al hacerlo, podemos identificar problemas y encontrar soluciones que quizás no habríamos considerado.

Obviamente, el patito en sí mismo no es necesario 🤣; cualquier objeto serviría como sustituto. La idea es que al hablar con algo que no nos responde,nos obligamos a pensar y explicar de manera más clara y a encontrar soluciones solos!

## Decoupling

Vamos a empezar a profundizar un poco más en el poder de las clases abstractas.

Dijimos que una de las utilidades es que en las _subclasses_ podíamos definir comportamientos específicos. Hagámoslo con las nuestras incorporando un campo en cada una: en `Manager` uno que represente la cantidad de proyectos manejados y en `Engineer` uno que represente la cantidad de _bugs_ solucionados; solo les voy a pegar el código que cambia:

```dart
  group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        projectsManaged: 10,
      );
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.projectsManaged, 10);
      expect(manager.reportToOwner, isA<Function>());
      expect(manager.askForRaise, isA<Function>());
    });
  });

  group('Given an Engineer', () {
    late Engineer engineer;
    setUp(() {
      engineer = Engineer(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        bugsFixed: 100,
      );
    });

    test(
        'When I create a Engineer, Then I get a Engineer with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(engineer.fullName, 'John Doe');
      expect(engineer.id, 1);
      expect(engineer.salary, 1000);
      expect(engineer.bugsFixed, 100);
      expect(engineer.reportToOwner, isA<Function>());
      expect(engineer.askForRaise, isA<Function>());
    });
  });
```

Ahora esto falla por lo que tenemos que actualizar nuestras clases:

```dart
class Manager extends Employee {
  Manager({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.projectsManaged,
  });

  final int projectsManaged;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  String reportToOwner() => 'I am a Manager and I\'ve managed this an that';
}

class Engineer extends Employee {
  Engineer({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.bugsFixed,
  });

  final int bugsFixed;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  String reportToOwner() =>
      'I am an Engineer and I\'ve engineered this an that';
}
```

Y qué podemos hacer con ellos? Recuerdan el método `measureProductivity` de nuestro `Owner`? Lo que podríamos hacer es multiplicar la cantidad de trabajo realizado por cada `Employee` y que arroje un total para cada uno según una medición arbitraria.

Vamos entonces a nuestro `company_example_example.dart` (claramente no pensé en esto cuando comencé con la sección 🤦🏻‍♂️), y allí crearemos un `Owner` con un método como el siguiente:

```dart
import 'package:company_example/company_example.dart';

void main() {
  final owner = Owner(
    fullName: 'Sarah Smith',
    measureProductivity: (Employee employee) {
      var productivity = 0;
      if (employee is Manager) {
        productivity = employee.projectsManaged * 10;
      } else if (employee is Engineer) {
        productivity = employee.bugsFixed * 5;
      } else {
        productivity = 0;
      }
      print('📇 The productivity of ${employee.fullName} is $productivity');
      return 'The productivity of ${employee.fullName} is $productivity';
    },
  );
}
```

Luego, podríamos ponerlo utilizarlo así:

```dart
import 'package:company_example/company_example.dart';

void main() {
  final owner = Owner(
    fullName: 'Sarah Smith',
    measureProductivity: (Employee employee) {
      var productivity = 0;
      if (employee is Manager) {
        productivity = employee.projectsManaged * 10;
      } else if (employee is Engineer) {
        productivity = employee.bugsFixed * 5;
      } else {
        productivity = 0;
      }
      print('📇 The productivity of ${employee.fullName} is $productivity');
      return 'The productivity of ${employee.fullName} is $productivity';
    },
  );

  final manager = Manager(
    fullName: 'John McEnroe',
    id: 1,
    salary: 1000,
    projectsManaged: 14,
  );

  final engineer = Engineer(
    fullName: 'Stuart Little',
    id: 1,
    salary: 1000,
    bugsFixed: 147,
  );

  owner.measureProductivity(manager);
  owner.measureProductivity(engineer);
}
```

Es genial porque podemos moldear la especificidad de nuestros empleados de forma acorde a su rol. A pesar de eso, pudieron observar que nuestro `Owner` cuando implementa su `measureProductivity` está obligado a saber qué sucede dentro de una clase o la otra? Tiene que saber que el `Engineer` tiene un campo `bugsFixed` y lo mismo con el `Manager`. Qué tal si pudiéramos cambiar un poquito las cosas para que sin importar cuál fuera el empleado, nuestro `Owner` pueda medir la productividad?

Iremos una vez más por partes para que pueda verse claro.

Recuerdan el método `reportToOwner`? Qué tal si en lugar de devolver una `String` devuelve un `int` con la cantidad de horas trabajadas? Tests _first_:

```dart
group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        projectsManaged: 10,
      );
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.projectsManaged, 10);
      expect(manager.reportToOwner, isA<int Function()>()); // 👁️
      expect(manager.askForRaise, isA<Function>());
    });
  });

  group('Given an Engineer', () {
    late Engineer engineer;
    setUp(() {
      engineer = Engineer(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        bugsFixed: 100,
      );
    });

    test(
        'When I create a Engineer, Then I get a Engineer with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(engineer.fullName, 'John Doe');
      expect(engineer.id, 1);
      expect(engineer.salary, 1000);
      expect(engineer.bugsFixed, 100);
      expect(engineer.reportToOwner, isA<int Function()>()); // 👁️
      expect(engineer.askForRaise, isA<Function>());
    });
  });
```

Ahora para que nuestros tests se arreglen:

```dart
abstract class Employee {
  Employee({
    required this.fullName,
    required this.id,
    required this.salary,
  });

  final String fullName;
  final int id;
  final double salary;

  int reportToOwner();
  String askForRaise();
}

class Manager extends Employee {
  Manager({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.projectsManaged,
  });

  final int projectsManaged;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  int reportToOwner() => projectsManaged * 7;
}

class Engineer extends Employee {
  Engineer({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.bugsFixed,
  });

  final int bugsFixed;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  int reportToOwner() => bugsFixed * 2;
}
```

Finalmente, con esto funcionando, podríamos cambiar nuestro _example example_ 😂:

```dart
import 'package:company_example/company_example.dart';

void main() {
  final owner = Owner(
    fullName: 'Sarah Smith',
    measureProductivity: (Employee employee) {
      final productivity = employee.reportToOwner() / 10;
      print('📇 The productivity of ${employee.fullName} is $productivity');
      return 'The productivity of ${employee.fullName} is $productivity';
    },
  );

  final manager = Manager(
    fullName: 'John McEnroe',
    id: 1,
    salary: 1000,
    projectsManaged: 14,
  );

  final engineer = Engineer(
    fullName: 'Stuart Little',
    id: 1,
    salary: 1000,
    bugsFixed: 147,
  );

  owner.measureProductivity(manager);
  owner.measureProductivity(engineer);
}
```

Ya el `Owner` no tiene que saber específicamente sobre la cantidad de proyectos en los que el `Manager` trabajó ni cuántos _bugs_ nuestro `Engineer` tuvo que solucionar; simplemente no los conoce porque __la clase abstracta `Employee` se encargó de establecer un contrato en el que obliga a todas las clases que la extiendan__ y esto nos permite 'desacoplar' capas o _decoupling_.

El término __se refiere a la separación de dos componentes o módulos para reducir la dependencia entre ellos__. Se trata de diseñar un sistema en el que las distintas partes están lo menos acopladas posible, lo que aumenta la flexibilidad y facilita el mantenimiento y la modificación del código.

En el contexto de las clases, como en el ejemplo que vimos, el decoupling se refiere a separar las clases en diferentes niveles de abstracción para reducir la dependencia entre ellas. En el caso del ejemplo, `Owner` no depende de las subclases de `Employee` (`Manager` y `Engineer`) directamente, sino que depende de la clase abstracta `Employee`. De esta manera, si se crea una nueva subclase de `Employee` en el futuro, `Owner` no se verá afectado siempre y cuando la nueva subclase implemente los métodos definidos en la clase abstracta `Employee`. Por ejemplo, podemos crear una nueva subclase de `Employee` llamada `Designer` que tiene un método adicional llamado `design()` y `Owner` puede medir su productividad sin tener que modificar su código existente

__Esta separación reduce la dependencia entre las diferentes partes del sistema y hace que el código sea más fácil de mantener y modificar en el futuro.__

Quiero cerrar este capítulo aclarando que la clase abstracta no se testea en sí misma sino con una instancia. Es por esto que los tests sobre `Employee` si los tuvieran, pueden borrarse tranquilamente!

## 💪 Transaccionando

__Requirement__:

Primero, crear una clase abstracta llamada `PaymentType` que tenga los siguientes atributos y métodos abstractos:

- `id` (`int`): identificador único del pago.
- `amount` (`double`): cantidad de dinero del pago.
- `processPayment()`: método abstracto que procesa el pago (imprime con qué fue
  realizado y retorna dicho tipo.)

Luego, crear dos subclases llamadas `CashPayment` y `PayPalPayment` que extiendan de la clase `PaymentType`.

`CashPayment` debe tener un constructor que acepte un parámetro `id` y un parámetro `amount`, y su método `processPayment()` debe imprimir "Paid amount: `$amount`" y retornar una `String` 'CashPayment'.

`PaypalPayment` debe tener un constructor que acepte un parámetro `id`, un `parámetro amount` y un parámetro del tipo `String` llamado `email`, y su método `processPayment()` debe imprimir "Paid amount: `$amount`" y retornar una `String` 'PaypalPayment'.

Luego, crear otra clase llamada `Transaction` que cuenta con los siguientes atributos:

- `id` (`int`): id del cliente.
- `fullName` (`String`): nombre completo del cliente.
- `paymentType` (`PaymentType`): tipo de pago elegido por el cliente.
- `processTransaction`: método que llama al `processPayment` del `PaymentType` e imprime con qué método de pago fue realizada.

Después, elaborar un ejemplo que ejecute 2 transacciones llamando a `processTransaction`, una con cada tipo de `PaymentType`. Todas las clases deben estar testeadas.

Finalmente en nuestro ejemplo, llamar a una clase que aun no creamos: 
`BankTransactionPayment` como si la ejecutáramos. Tiene que tener `id`, `amount` y `bankAcount`, además del método `processPayment`. Crear sus tests, la clase y responder el porqué la clase `Transaction` siguió funcionando sin tener que ser modificada.

__💀 Solución__:
[abstract_classes_exercise](https://pub.dev/)

No tenemos que modificar la clase Transaction para poder agregar un nuevo tipo de pago, ya que dicha clase recibe un objeto de tipo PaymentType e interactúa con sus métodos; la implementación de los métodos de PaymentType es responsabilidad de las clases que heredan de PaymentType.
