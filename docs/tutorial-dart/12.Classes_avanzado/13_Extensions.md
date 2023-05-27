---
sidebar_position: 13
---

# Extensions

Supongamos que tenemos un texto y nos gustaría volver mayúsculas solamente la primer letra de cada palabra. Qué podríamos hacer? Lo primero, claramente, sería crear un test para ello. 💀 Vayan que yo los espero en el próximo párrafo:

```dart
import 'package:test/test.dart';

void main() {
  test('Given a String, When called with capitalizeFirst, Then the result should be the same String with each of the words with its first letter in capital letter', () {
    final result = capitalizeFirst('hello world');
    expect(result, 'Hello World');
  });
}
```

Tenemos nuestro texto y ahora podríamos crear una función para ello:

```dart
String capitalizeFirst(String text) {
  // Separamos el texto en palabras
  final words = text.split(' ');
  // Capitalizamos cada palabras
  final capitalizedWords = words.map((word) {
    final firstLetter = word[0].toUpperCase();
    final restOfWord = word.substring(1);
    return '$firstLetter$restOfWord';
  });
  // Unimos las palabras capitalizadas en un solo String mediante un espacio en
  // blanco
  return capitalizedWords.join(' ');
}
```

Y podríamos ver que todos nuestros tests corren perfectamente. Ahora bien, qué tal sería que dicho método pueda ser llamado en cada `String` como hacemos con `toUpperCase` por ejemplo? Para ello, entre otras cosas, sirven las extensiones y son muy fáciles de agregar:

```dart
import 'package:test/test.dart';

void main() {
  test(
      'Given a String, When called with capitalizeFirst, Then the result should be the same String with each of the words with its first letter in capital letter',
      () {
    final result = 'hello world'.capitalizeFirst();
    expect(result, 'Hello World');
  });
}

extension on String {
  String capitalizeFirst() {
    // Separamos el texto en palabras
    final words = split(' ');
    // Capitalizamos cada palabras
    final capitalizedWords = words.map((word) {
      final firstLetter = word[0].toUpperCase();
      final restOfWord = word.substring(1);
      return '$firstLetter$restOfWord';
    });
    // Unimos las palabras capitalizadas en un solo String mediante un espacio en
    // blanco
    return capitalizedWords.join(' ');
  }
}
```

__Las extensiones permiten agregar nuevos métodos a una clase existente sin tener que heredar de ella ni modificar su código fuente.__ En lugar de eso, se define un método fuera de la clase, pero que actúa sobre una instancia de esa clase.

__Se definen utilizando la palabra clave `extension`, seguida del nombre de la clase a la que se agregará el método, y luego el cuerpo del método.__

💀 Ahora sin embargo, prueben llevar la extensión a otro archivo y vean qué pasa.

## Nombrando las extensiones

Para que una extensión pueda ser colocada en un archivo diferente al archivo en donde van a utilizarla, dicha extensión debe nombrarse y una forma muy común de hacerlo es agregando, si se trata de una clase conocida como `String` una `X` al nombre:

```dart
extension StringX on String {
  String capitalizeFirst() {
    // Separamos el texto en palabras
    final words = split(' ');
    // Capitalizamos cada palabras
    final capitalizedWords = words.map((word) {
      final firstLetter = word[0].toUpperCase();
      final restOfWord = word.substring(1);
      return '$firstLetter$restOfWord';
    });
    // Unimos las palabras capitalizadas en un solo String mediante un espacio en
    // blanco
    return capitalizedWords.join(' ');
  }
}
```

De esta manera, podemos utilizarla donde queramos solamente teniendo que importarla.

## Diferentes usos

Son __muy útiles para agregar funcionalidades a clases existentes sin necesidad de crear subclases o cambiar la implementación original de la clase__. Vamos a ver algunos usos muy comunes:

1. Agregar métodos de utilidad a clases preexistentes creadas por uno mismo.

2. Proporcionar métodos de conversión entre diferentes tipos de objetos, como convertir una lista de `String` en una lista de `int`.

3. Extender la funcionalidad de clases existentes en paquetes de terceros que no se pueden modificar directamente.

4. Simplificar la sintaxis de una clase existente para hacerla más fácil de usar o más intuitiva para los desarrolladores que la utilizan.

5. Personalizar la implementación de una clase en función de las necesidades específicas del proyecto, sin cambiar la implementación original de la clase.

6. Proporcionar funcionalidad adicional a los tipos básicos, como agregar métodos de validación a la clase `String` o agregar métodos de redondeo a la clase `num`.

Veremos luego, cuando utilicemos Flutter, ejemplos bien claros y otros muy creativos sobre cómo utilizarlas!

## 💪 Extendiendo un paquete de otros

__Requirement__:

Extender la clase `DateTime` con una función llamada `increment` que agregue un día a una fecha creada con `DateTime.now()`. Deben crear un test que permita comparar una fecha creada y luego incrementada.

__Clue__: pueden utilizar el método `difference` para su test.

---

__💀 Solución__:

```dart

import 'package:test/test.dart';

void main() {
  test(
      'Given a DateTime, When called with increment, Then the result should be  a DateTime with one day incremented',
      () {
    final today = DateTime.now();
    final tomorrow = today.increment();
    expect(tomorrow.difference(today), Duration(days: 1));
  });
}

extension DateTimeX on DateTime {
  DateTime increment() {
    return add(Duration(days: 1));
  }
}
```

## Generics y Extensions

Supongamos que hacemos una extensión para sumar los valores de una lista. Un test podría verse de la siguiente manera:

```dart
void main() {
  test(
      'Given a list of int, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = [1, 2, 3, 4, 5];
    final result = list.sum();
    expect(result, 15);
  });
}
```

Y podríamos utilizar la función `reduce` para ellos y extender un `Iterable` del tipo `int`:

```dart
extension IterableX on Iterable<int> {
  int sum() => reduce((int value, int element) => value + element);
}
```

Sin embargo, qué sucede si queremos introducir un `double` en esa lista? Bien, podríamos hacer algo así:

```dart
import 'package:test/test.dart';

void main() {
  test(
      'Given a list of int, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = [1, 2, 3, 4, 5];
    final result = list.sum();
    expect(result, 15);
  });

  test(
      'Given a list of num, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = [1, 2, 3, 4, 5.5];
    final result = list.sum();
    expect(result, 15.5);
  });
}

extension IterableX on Iterable<num> {
  num sum() => reduce((num value, num element) => value + element);
}
```

Lo probaron? O solamente están leyendo y pasando cosas por alto? 💀 Si no lo hicieron vayan a probarlo y descubrir qué tienen que agregar para que el código anterior funcione!

```dart
  test(
      'Given a list of int, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = <num>[1, 2, 3, 4, 5]; //👁️ Si no se especifica el tipo, se infiere a partir de los elementos de la lista (int) y el método sum() no funciona
    final result = list.sum();
    expect(result, 15);
  });
```

Sin embargo, yo quiero ser más específico a la hora de testear porque por ejemplo, luego de dicho resultado, podría querer aplicar algún método solamente utilizable en `int` o en `double` y ya no nos serviría usar `num`. Para ello, podemos utilizar genéricos!

### Generic Type Constraints

Las limitaciones de tipo genéricas son una __característica que permite especificar restricciones sobre los tipos que se pueden utilizar como argumentos genéricos en una definición de clase o método genérico.__ Esto significa que, en lugar de permitir que cualquier tipo se use como argumento genérico, se pueden imponer ciertas restricciones en los tipos que se permiten.

Para ello utilizamos la sintaxis `<T extends SomeType>`, donde `T` es el parámetro genérico y `SomeType` es el tipo al que se le está restringiendo `T`.

En el caso anterior, podríamos hacer lo siguiente:

```dart
extension IterableX<T extends num> on Iterable<T> {
  T sum() => reduce((T value, T element) => (value + element) as T); //👁️ Se especifica el tipo de retorno ya que Dart no puede hacer utilizando la sintaxis (T + T) as T
}
```

Y luego, podríamos hacer algo como lo siguiente:

```dart
void main() {
  test(
      'Given a list of int, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = <int>[
      1,
      2,
      3,
      4,
      5
    ]; //👁️ Si no se especifica el tipo, se infiere a partir de los elementos de la lista (int) y el método sum() no funciona
    final result = list.sum();
    expect(result, 15);
    expect(result.isEven, false); //👁️ El resultado es un int y por ello puedo utilizar los métodos de la clase int
  });

  test(
      'Given a list of num, When called with .sum(), Then it should return the sum of its items',
      () {
    final list = <double>[1, 2, 3, 4, 5.5];
    final result = list.sum();
    expect(result, 15.5);
    expect(result.floor(), 15); //👁️ El resultado es un double y por ello puedo utilizar los métodos de la clase double
  });
}
```
