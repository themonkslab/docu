---
sidebar_position: 8
title: 8. Classes with generics
---

# Classes with generics

@Mau Di Bert

Ya hemos visto los genéricos pero vamos a jugar un poquito más aplicándolos a clases. Empezaremos creando un nuevo paquete llamado `generic_classes`.

Recordemos que los genéricos permiten que una clase, función o método trabaje con diferentes tipos de datos, sin tener que conocer de antemano qué tipo de datos serán, permiten escribir código más flexible y reutilizable.

## Parecido a la vida real

Algo que van a hacer todo el tiempo cuando construyan sus aplicaciones, es pedir información fuera de la aplicación. Si bien ya veremos en detalle cómo sucede este proceso ahora me interesa que sepan que se resume de la siguiente manera:

1. Hacemos un pedido desde nuestra aplicación a un servidor (_server_), una computadora que contiene información.
2. Según lo que suceda, podemos tener a muy grandes rasgos, dos tipos de resultados: _success_ (éxito) o _error_ (🤷🏻‍♂️).
3. Presentamos ese resultado al usuario.

__Es muy importante que el usuario en todo momento sepa qué está sucediendo en nuestra aplicación por lo que no solamente tenemos que mostrar los casos de éxitos (_happy path_ comúnmente llamado en inglés) sino también los casos de fallo__ para que el usuario sepa qué hacer en ese momento.

Lo que quiero que creemos en este ejemplo es una clase que represente dicho resultado.

## Simulando un request

__Vamos a empezar a simular cómo sería un llamado a un servidor o también llamado un _request_ (pedido).__ No vamos a complicarnos con métodos asíncronos o métodos que demoran un tiempo y vamos a tener que esperar. Por ahora simplemente vamos a crear un método llamado `processRequest` que nos retorne una `String` si se trata de un error simulado o un tipo random según nosotros le digamos.

Para ello, vamos a los tests de nuestro nuevo paquete y allí crear un grupo de la siguiente manera `group('Given a call to processRequest', () {});`.

Allí, vamos a situar todos los requerimientos de nuestro método. Empecemos!

Dijimos que ese método tenía que retornar un error o un éxito. Estaría bueno que podamos decidir nosotros al momento de llamarlo si queremos que retorne un tipo o el otro o lo que es lo mismo que decir, si queremos que produzca un fallo. 
Podríamos hacerlo así:

```dart
import 'package:test/test.dart';

void main() {
  group('Given a call to processRequest', () {
    test(
        'When I call it with returnError = true, Then the result should be a String',
        () {});
  });
}
```

Ya tenemos el caso de uso o _use case_. Vamos a implementarlo y cuando digo vamos, es 💀, vayan a implementarlo:

```dart
import 'package:test/test.dart';

void main() {
  group('Given a call to processRequest', () {
    test(
        'When I call it with returnError = true, Then the result should be a String with value Error',
        () {
      final result = processRequest(returnError: true);
      expect(result, isA<String>());
      expect(result, 'Error');
    });
  });
}
```

Varias cosas podemos ver en este ejemplo. En primer lugar, la función `processRequest` recibe un parámetro `bool` para saber si tiene que arrojar un error o algo más. Por otro lado, ese resultado puede o bien ser un error o bien algo más si la operación fue exitosa, por ahora en ambos casos, se tratará de un `String`. Finalmente, si va a ser un error, dicha `String` será `'Error'`.

__Ahora ya con nuestro caso de uso implementado, estamos obligados a dejar de hacerlo fallar, implementando nuestro método.__ Vamos?

En el `generic_classes_base.dart` dentro de `lib/src`,💀 vayan a crear el método prestando atención en lo que hablamos. No hace falta que implementen el caso de éxito sino solamente el de error, aprendiendo así a no hacer _over-engineer_ que se refiere a la práctica de diseñar, construir o implementar algo de una manera más complicada o sofisticada de lo necesario (puede ser un problema ya que puede aumentar el costo y la complejidad sin agregar valor real o mejorar la calidad).

Esto es lo que hice:

```dart
processRequest({required bool returnError}) {
  if (returnError) {
    return 'Error';
  }
}
```

Muy simple verdad?. Si lo importamos en nuestro test, debería dar todo correctamente! Me alegro así haya sido! Hagan lo mismo con el otro caso de uso.

```dart
    test(
        'When I call it with returnError = false, Then the result should be a String with value Success',
        () {
      final result = processRequest(returnError: false);
      expect(result, isA<String>());
      expect(result, 'Success');
    });
```

Si lo corren ahora, van a poder observar cómo falla ya que el `return` ahora es`null`. Vayan a corregir la implementación hasta que el test de correctamente:

```dart
processRequest({required bool returnError}) {
  if (returnError) {
    return 'Error';
  }
  return 'Success';
}
```

Ahora vamos a empezar a ajustarnos al requerimiento inicial: esta clase debería poder retornar un tipo _random_ o aleatorio si se trata de un caso de éxito y un tipo específico de fallo si se trata de un error. Podríamos suponer una implementación como la siguiente:

```dart
// Importamos la librería 'dart:math' para poder usar la clase 'Random'
import 'dart:math';

processRequest({required bool returnError}) {
  // Creamos una lista con varios tipos de datos
  var randomResult = [1, true, 'Hello', 3.14, 'World', false, 2];
  if (returnError) {
    // Si 'returnError' es true, devolvemos un error del tipo 'Failure' que aun
    // no hemos definido
    return Failure('This is an error');
  }

  // La clase Random nos permite generar números aleatorios en un rango
  // determinado. En este caso, generamos un número aleatorio entre 0 y 6.
  // El método 'nextInt' devuelve un número entero aleatorio entre 0 y el
  // número que le pasemos como parámetro.
  // Dichos números se corresponden con los índices de la lista 'randomResult'
  return randomResult[Random().nextInt(7)];
}
```

Vamos a ir por partes. Primero qué les parece si creamos una clase `Failure` que reciba un `String` a modo de mensaje para comunicar qué sucedió? Con ella van a ver que nuestro método deja de fallar.

```dart
class Failure {
  final String message;
  Failure(this.message);
}
```

Ahora bien: cómo podemos realizar un test de un método como el anterior? Hasta ahora solo retornaba un `String` que podríamos haberlo especificado antes de la siguiente manera:

```dart
String processRequest({required bool returnError}) {
  if (returnError) {
    return 'Error';
  }
  return 'Success';
}
```

Sin embargo, ya no es el caso con el nuevo método ya que podría retornar un `String` o bien cualquier otro tipo. Podríamos utilizar un retorno de tipo `dynamic` pero no sabríamos si dicho retorno es un error o es un caso de éxito. Cómo podemos hacer?

## Creando la clase Result

Podríamos crear una clase llamada `Result` que pueda alojar ambos tipos de resultados, en `value` y `error`, siendo este último del tipo `Failure`. Vamos de a poco si? 💀 Arranquen desde la creación de un test de dicha clase en donde la inicialicemos con un caso de éxito y corroboremos que el resultado no sea un `Failure`:

```dart
  group('Given a Result class', () {
    late Result result;
    test(
        'When created with a success use case, Then Result.value should not be a Failure',
        () {
      result = Result('Success');
      expect(result.value, isNot(isA<Failure>()));
    });
  });
```

Ya con esto, tenemos material suficiente para crear nuestro primer `Result`. 💀 Háganlo ustedes primero si? Vale mencionar que tienen que correr solamente los tests de este grupo ya que el grupo que creamos antes destinado a testear `processRequest` va a comenzar a fallar.

```dart
class Result {
  final dynamic value;
  final Failure? error;

  Result({this.value, this.error});
}
```

Qué les parece si testeamos el caso inverso?

```dart
      test(
         'When created with an error use case, Then Result.error should be a Failure',
         () {
      result = Result(error: Failure('Error'));
      expect(result.error, isA<Failure>());
      });
```

## Generics in methods

Vamos aunque no me convence tener dentro del `Result` representado como caso de éxito un `value` del tipo `dynamic`. Por qué? En la mayoría de los casos cuando hagan una petición (otra forma de llamar al _request_), van a saber qué tipo tiene que retornar; no es que van a tener un tipo aleatorio. De esta forma, si nosotros quisiéramos poder trabajar con el resultado, no podríamos hacerlo.
Déjenme ejemplificarlo:

```dart
    test(
        'When created with a success use case, Then Result.value should be an int',
        () {
      result = Result(value: 'Success');
      expect(result.value, isA<int>());
    });
```

Eso sería un test de una parte de nuestra aplicación que haría un _request_ en el que sabemos que si todo salió de la manera esperada, deberíamos tener un `int` como resultado; sino, un `String`. Sin embargo, nuestra clase `Result` nos permite instanciarla con un valor del tipo `String` por lo que obviamente dicho test va a fallar.

__Cómo podríamos restringir el tipo de valor que queremos en nuestra clase?__ Podríamos utilizar _generics_. Cómo lo hacemos? Ya lo mencionamos cuando los utilizábamos en funciones pero sucederá lo mismo en las clases: entre `< >` ponemos una letra mayúscula para representar lo que esperamos que reciba, utilizando alguna de las convenciones siguientes:

- `E` para elemento.
- `K` y `V` para key y value respectivamente.
- `R` para un tipo de retorno.
- `T`, `S` y `U` para tipos genéricos.
- Si ninguno de los tipos anteriores sirvió a nuestros fines, cualquier letra mayúscula puede servir.

Si creamos nuestra clase recibiendo un genérico:

```dart
class Result<T> {
  final T? value;
  final Failure? error;

  Result({this.value, this.error});
}
```

Podremos luego entonces, hacer esto:

```dart
    test(
        'When created with a success use case, Then Result.value should be an int',
        () {
      result = Result<int>(value: 1);
      expect(result.value, isA<int>());
    });
```

Cómo nos damos cuenta de que esto nos sirve? Prueben hacer lo siguiente:

```dart
    test(
        'When created with a success use case, Then Result.value should be an int',
        () {
      result = Result<int>(value: 'Success');
      expect(result.value, isA<int>());
    });
```

No nos deja ni siquiera compilar ya que nos dice que el valor del tipo `String` no puede asignarse a uno del tipo `int` y esto es hermosamente poderoso ya que nos permite tener una clase que podremos reutilizar tantas veces como queramos:

```dart
    test(
        'When created with a success use case of value type int, Then Result.value should be an int',
        () {
      result = Result<int>(value: 1);
      expect(result.value, isA<int>());
    });

    test(
        'When created with a success use case  of value type String, Then Result.value should be a String',
        () {
      result = Result<String>(value: 'Success');
      expect(result.value, isA<String>());
    });
    test(
        'When created with a success use case  of value type bool, Then Result.value should be a bool',
        () {
      result = Result<bool>(value: false);
      expect(result.value, isA<bool>());
    });
```

Incluso, podríamos pasarle otro parámetro e incluso limitar nuestro `Result` de la siguiente manera:

```dart
class Result<T, F extends Exception> {
  final T? value;
  final F? error;

  Result({this.value, this.error});
}
```

Esto nos permitiría obligar a que el error pueda lanzar una `Exception`:

```dart
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}
```

```dart
    test(
        'When created with an error use case, Then Result.error should be an AppException',
        () {
      result = Result<int, AppException>(error: AppException('Error'));
      expect(result.error, isA<AppException>());
      expect(() => throw(result.error!), throwsException); //👁️
    });
```

Y una __importante aclaración:  en Dart, las excepciones no son valores, por lo que no pueden ser pasadas directamente como argumentos de una función. En lugar de eso, se necesita envolver la excepción en una función anónima que la lance para que la función `expect` pueda capturar la excepción.__

En este caso específico, `expect(() => throw(result.error!), throwsException);` está diciendo que espera que la función anónima que se pasa como argumento `(() => throw(result.error!))` lance una excepción (`throwsException`). Es decir, el test espera que cuando se llame a la función anónima, esta lance la excepción `result.error!` y que el test capture dicha excepción.

## 💪 Poniendo los tests al día

__Requirement__: actualicen todos los tests para adaptarse a estos últimos modelos.

```dart
// Importamos la librería 'dart:math' para poder usar la clase 'Random'

import 'dart:math';

Result<int, AppException> processRequest({required bool returnError}) {
  // Creamos una lista con un tipo de dato genérico int
  var randomResult = [1, 0, 1, 1, 0, 1, 0];
  if (returnError) {
    return Result(error: AppException('This is an error'));
  }

  return Result(value: randomResult[Random().nextInt(6)]);
}

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class Result<T, F extends Exception> {
  final T? value;
  final F? error;

  Result({this.value, this.error});
}
```

__Solución__:

```dart
import 'package:generic_classes/generic_classes.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Result class', () {
    late Result result;
    test(
        'When created with a success use case, Then Result.value should not be an AppException',
        () {
      result = Result(value: 'Success');
      expect(result.value, isNot(isA<AppException>()));
    });

    test(
        'When created with a success use case of value type int, Then Result.value should be an int',
        () {
      result = Result<int, AppException>(value: 1);
      expect(result.value, isA<int>());
    });

    test(
        'When created with a success use case  of value type String, Then Result.value should be a String',
        () {
      result = Result<String, AppException>(value: 'Success');
      expect(result.value, isA<String>());
    });
    test(
        'When created with a success use case  of value type bool, Then Result.value should be a bool',
        () {
      result = Result<bool, AppException>(value: false);
      expect(result.value, isA<bool>());
    });

    test(
        'When created with an error use case, Then Result.error should be an AppException',
        () {
      result = Result<int, AppException>(error: AppException('Error'));
      expect(result.error, isA<AppException>());
      expect(() => throw (result.error!), throwsException);
    });
  });

  group(
    'Given a call to processRequest',
    () {
      test(
          'When I call it with returnError = true, Then the result should be a Result with value of AppException and message This is an error',
          () {
        final result = processRequest(returnError: true);
        expect(result.error, isA<AppException>());
        expect(result.error?.message, 'This is an error');
      });

      test(
          'When I call it with returnError = false, Then the result should be a Result with value of type int',
          () {
        final result = processRequest(returnError: false);
        expect(result.value, isA<int>());
      });
    },
  );
}
```

## Composition vs Inheritance

Ya vimos que herencia y composición son dos patrones importantes que se utilizan para __establecer relaciones entre las clases y los objetos.__

__La herencia__ se refiere a la __capacidad de una clase de heredar las propiedades y comportamientos de otra clase__. En otras palabras, una clase hereda de otra clase los atributos y métodos que ésta define. La clase que hereda se llama "clase hija" o "subclase", mientras que la clase que se hereda se llama "clase padre" o "superclase". La herencia puede ser __útil para reutilizar código y crear jerarquías de clases.__

Por otro lado, __la composición__ se refiere a __la capacidad de una clase de tener un objeto de otra clase como un miembro o propiedad__. En otras palabras, una clase compuesta tiene una instancia de otra clase. La clase compuesta utiliza los métodos y propiedades del objeto que contiene para realizar sus operaciones. La composición puede ser __útil para crear objetos más complejos y para agregar funcionalidades de forma modular__.

En resumen, la herencia establece una relación de "es un" entre las clases (una subclase "es una" superclase), mientras que la composición establece una relación de "tiene un" entre las clases (una clase compuesta "tiene un" objeto de otra clase).  __La herencia es una buena opción cuando hay muchas similitudes entre los elementos que estamos modelando, mientras que la composición es mejor cuando hay diferencias significativas entre ellos.__

Ambos conceptos son importantes y pueden ser utilizados en diferentes situaciones, dependiendo de los requerimientos del diseño y la arquitectura.
