---
sidebar_position: 11
---

# Mutabilidad e Inmutabilidad

Supongamos que necesitamos una clase dentro de una aplicación de personal que controle los horarios de salida y entrada de los empleados. Podríamos crear esta clase (y las clases necesarias para que esta funcione), de la siguiente manera:

```dart
class EmployeeSchedule {
  final String employeeId;
  final Map<DayOfWeek, TimeOfDay> startTimeMap;
  final Map<DayOfWeek, TimeOfDay> endTimeMap;

  EmployeeSchedule(
    this.employeeId,
    this.startTimeMap,
    this.endTimeMap,
  );
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay(this.hour, this.minute);
}
```

Una vez que contamos con lo anterior, podríamos utilizarlo de la siguiente manera:

```dart
void main() {
  // Definimos los horarios de trabajo de un empleado utilizando el constructor 
  final employee1Schedule = EmployeeSchedule(
    employeeId: '001',
    startTimeMap: {
      DayOfWeek.monday: TimeOfDay(9, 0),
      DayOfWeek.tuesday: TimeOfDay(8, 30),
      DayOfWeek.wednesday: TimeOfDay(9, 15),
      DayOfWeek.thursday: TimeOfDay(10, 0),
      DayOfWeek.friday: TimeOfDay(9, 0),
      DayOfWeek.saturday: TimeOfDay(0, 0),
      DayOfWeek.sunday: TimeOfDay(0, 0),
    },
    endTimeMap: {
      DayOfWeek.monday: TimeOfDay(17, 0),
      DayOfWeek.tuesday: TimeOfDay(17, 30),
      DayOfWeek.wednesday: TimeOfDay(18, 15),
      DayOfWeek.thursday: TimeOfDay(16, 30),
      DayOfWeek.friday: TimeOfDay(17, 0),
      DayOfWeek.saturday: TimeOfDay(0, 0),
      DayOfWeek.sunday: TimeOfDay(0, 0),
    },
  );

  // Imprimimos los horarios de trabajo del empleado
  print('Horario de trabajo de empleado 1:');
  print('ID: ${employee1Schedule.employeeId}');
  for (final day in DayOfWeek.values) {
    final TimeOfDay startTime = employee1Schedule.startTimeMap[day]!;
    final TimeOfDay endTime = employee1Schedule.endTimeMap[day]!;
    print('${day.toString().split('.').last}: ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}');
  }
}
```

Ahora bien. Gracias a que el constructor define a `startTimeMap` como `final` es que no podemos hacer lo siguiente: `employee1Schedule.startTimeMap = {}` y poner cualquier cosa que querramos. El haber establecido cada una de esas variables como `final` nos asegura la inmutabilidad de dicha clase, evitándonos variosdolores de cabeza.

La __inmutabilidad es importante en la creación de clases__ por varias razones:

- _Seguridad_: Al hacer que los objetos sean inmutables, se reduce el riesgo de que se produzcan errores inesperados en la lógica del programa. Si los objetos pueden cambiar en cualquier momento, es difícil rastrear cuándo y por qué se producen cambios, lo que puede generar errores difíciles de depurar. Los objetos inmutables, en cambio, garantizan que su estado no cambiará después de su creación, lo que simplifica la lógica del programa y reduce los errores.

- _Confiabilidad_: Los objetos inmutables son más confiables porque su estado no cambia después de su creación. Esto los hace más fáciles de usar en sistemas distribuidos y paralelos, donde varios procesos pueden acceder a los mismos objetos al mismo tiempo. Si los objetos son mutables, es difícil garantizar que su estado no cambiará mientras se accede a ellos desde diferentes procesos.

- _Simplicidad_: La inmutabilidad hace que el diseño de clases sea más simple y fácil de entender. Si un objeto no puede cambiar, es más fácil razonar sobre su estado y su comportamiento. Además, las clases inmutables suelen ser más fáciles de implementar y mantener porque no tienen que preocuparse por el estado mutable.

No obstante, podría existir un _manager_ de recursos humanos que necesita una funcionalidad que le permita actualizar o corregir algún horario. Cómo haría en este caso?

## El método copyWith

Es muy común observar este método cuando se crea una clase ya que __nos permite retornar una nueva instancia de la clase pero solamente cambiando aquellos valores que le pasamos como parámetro, siendo todos los parámetros de la función opcionales__:

```dart
class EmployeeSchedule {
  final String employeeId;
  final Map<DayOfWeek, TimeOfDay> startTimeMap;
  final Map<DayOfWeek, TimeOfDay> endTimeMap;

  EmployeeSchedule({
   required this.employeeId,
   required this.startTimeMap,
   required this.endTimeMap,
  });

  EmployeeSchedule copyWith({
    // Cada uno de los parámetros de este método es opcional
    String? employeeId,
    Map<DayOfWeek, TimeOfDay>? startTimeMap,
    Map<DayOfWeek, TimeOfDay>? endTimeMap,
  }) {
    // Si no se pasa un valor, se utiliza el valor de la instancia actual
    return EmployeeSchedule(
      employeeId: employeeId ?? this.employeeId,
      startTimeMap: startTimeMap ?? this.startTimeMap,
      endTimeMap: endTimeMap ?? this.endTimeMap,
    );
  }
}
```

Así eso nos permitiría hacer algo como: `final employee1ScheduleUpdate = employee1Schedule.copyWith(employeeId: '002');`, suponiendo que por alguna razón el `employeeId` de dicho empleado fue creado de forma incorrecta.

## Cascade operator

El __operador de cascada (..) es una característica que permite invocar varios métodos en un objeto sin tener que repetir el nombre del objeto__. Es decir, podemos encadenar una serie de llamadas a métodos en una sola línea de código.

Se utiliza comúnmente para crear objetos complejos y personalizarlos de manera eficiente ya que en lugar de crear un objeto, asignarlo a una variable y luego invocar varios métodos en la variable, podemos utilizar el operador de cascada para invocar los métodos directamente en el objeto.

Por ejemplo, para crear una lista y agregar varios elementos, podemos hacer lo siguiente:

```dart
var myList = List<int>()
  ..add(1)
  ..add(2)
  ..add(3);
```

También __se puede utilizar en combinación con constructores y _setters_ para personalizar objetos__. Por ejemplo, para crear un objeto `Person` y establecer varias propiedades, podemos hacer:

```dart
class Person {
  String name;
  int age;
  String email;
  
  void printDetails() {
    print('Name: $name');
    print('Age: $age');
    print('Email: $email');
  }
}

var person = Person()
  ..name = 'John'
  ..age = 30
  ..email = 'john@example.com';

person.printDetails(); // Name: John Age: 30 Email: john@example.com
```

Y qué relación tiene este _cascade operator_ con la mutabilidad? __Este operador se puede utilizar tanto con objetos mutables como con objetos inmutables aunque cuando se utiliza con objetos mutables, va a producir cambios en el estado del objeto original.__

En general, __es una buena práctica utilizar clases inmutables para garantizar una gestión más segura y predecible de los estados__ y evitar efectos secundarios no deseados. Sin embargo, __en algunos casos puede ser apropiado utilizar clases mutables__.

Supongamos que estamos que estamos creando una aplicación de temporizador que muestra el tiempo restante y la cuenta regresiva para un evento. Necesitaríamos actualizar el tiempo restante en tiempo real y puede ser apropiado utilizar una clase mutable para almacenar y actualizar esta información.

Por ejemplo, podríamos crear una clase `Countdown` que almacene el tiempo restante y tenga un método `tick()` que se llame cada segundo para actualizar el tiempo restante:

```dart
class Countdown {
  int timeRemaining;
  
  Countdown(this.timeRemaining);
  
  void tick() {
    timeRemaining--;
    print('Tiempo restante: $timeRemaining');
  }
}
```

Podemos utilizar acá el _cascade operator_ en lugar de llamar al constructor de `Countdown` y hacer ambas cosas en una sola línea de código:

```dart
void main() {
  var countdown = Countdown(10)
    ..tick()
    ..tick()
    ..tick();
}
```

Para dar un cierre a este capítulo, podemos decir que __en general nos inclinamos por clases inmutables salvo al trabajar con valores que cambian con frecuencia, que pueden ser actualizados en tiempo real o bien con colecciones de datos (como listas y mapas).__
