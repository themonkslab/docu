---
sidebar_position: 10
title: 10. Paquetes, grupos y late en tests
---

# Paquetes, grupos y late en tests

@Mau Di Bert

Desde la siguiente sección, vamos a tratar en la mayoría de los casos, de partir desde el diseño de nuestros tests, para luego implementar el código que los solucione.

Como vamos a empezar con cuestiones avanzadas sobre _Classes_, vamos a ver dentro de esta sección, un par de conceptos más que nos serán de extrema utilidad, antes de adentrarnos de lleno en contenido más avanzado.

## Creando un paquete y jugando con groups

Supongamos que queremos representar a distintos tipos de animales. Podemos decir que todos los animales necesitan dormir, comer y reproducirse pero no todos por ejemplo, pueden volar.

Vamos a empezar en esta oportunidad escribiendo un test pero para ello tenemos que crear que crear un paquete. Recuerdan cómo hacerlo? Vamos a crear un paquete que compartiremos a lo largo de toda esa sección.

Si creamos un paquete con Dart (pueden hacerlo rápidamente con `cmd` + `shift` + `p` en VSCode, escribiendo Dart y seleccionando 'New Project'), esto es lo que van a ver:

Una carpeta `example`, que es la que tiene nuestro `main` o punto de ingreso:

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
}
```

Una carpeta `lib/src` que tiene la funcionalidad de nuestro paquete, en la librería:

```dart
// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}
```

Y la carpeta `test`:

```dart
import 'package:classes_advanced/classes_advanced.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
```

Si nos concentramos en los primeros dos archivos (dentro de las primeras dos carpetas mencionadas), podemos ver la clase `Awesome`. Ella tiene un _getter_ llamado `isAwesome` ('es increíble'). En la función `main`, instanciamos la clase y luego imprimimos algo con su _getter_.

Luego, si nos movemos al único test, van a encontrar un par de cosas nuevas: `group` y `setUp`. Cada función tiene varios parámetros de configuración pero vamos a ir de a poco.

La función `group`, nos permite agrupar nuestros tests. El primer parámetro sirve para introducir una `String` a modo de descripción que va a ser incluída en cada descripción de los tests que lo integren. Observen el siguiente ejemplo:

```dart
group('A group description', () {
    test('...that goes here.', () {
    });
    test('...that goes also here.', () {
    });
    test('...that goes finally here too.', () {
    });
  });
```

Cuando corran esos tests, es esto lo que verán en la consola:

```shell
✓ A group description ...that goes here.
✓ A group description ...that goes also here.
✓ A group description ...that goes finally here too.
Exited
```

Por otro lado, la función `setUp` registra un _callback_ que va a ser ejecutado antes de cada test. Supongan el siguiente ejemplo:

```dart
import 'package:classes_advanced/classes_advanced.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      print('🚧 setup');
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });

    test('Second Test', () {
      expect(!awesome.isAwesome, isFalse);
    });
  });
}
```

Es esto lo que verían en su consola:

```shell
🚧 setup
✓ A group of tests First Test
🚧 setup
✓ A group of tests Second Test
Exited
```

Pueden observar que para cada test, se corrió una vez la función `setUp`. Qué pueden deducir del siguiente ejemplo? 💀 Tómense un tiempo para pensarlo:

```dart
import 'package:classes_advanced/classes_advanced.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      print('🚧 setup');
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });

    test('Second Test', () {
      expect(!awesome.isAwesome, isFalse);
    });
  });

  test('A test out of the group', () {
    expect(1, 1);
  });
}
```

Pudieron ver qué sucedió? El `group` define un _inner scope_, un ámbito en el cual instancia el `Awesome`, registra un `setUp` y demás. Todo lo que suceda allí es solamente funcional dentro del grupo. Por ello, nuestro test final, aquél fuera del `group`, no imprime el '🚧 setup':

```shell
🚧 setup
✓ A group of tests First Test
🚧 setup
✓ A group of tests Second Test
✓ A test out of the group
Exited
```

Dicho todo lo anterior, vamos a borrar todo en el archivo `classes_advanced_test.dart` salvo el `main`, lo mismo en el `classes_advanced_example.dart` y todo en el `classes_advanced_base.dart`.

Empecemos a escribir un test que nos permita comprobar la creación de una clase llamada `Animal` que pueda comer, dormir y respirar. 💀 Intenten hacerlo ustedes.

Yo lo haría de la siguiente manera:

```dart
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    test('when sleep is called, then should print sleeping', () {});
    test('when eat is called, then should print eating', () {});
    test('when breath is called, then should print breathing', () {});
  });
}
```

Perfecto! Ya lo tenemos. Ahora bien, qué es lo primero que deberíamos tener para poder testar un `Animal`? Exacto, la clase `Animal`. Yo podría entonces escribir algo así:

```dart
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    test('when sleep is called, then it should print "sleeping"', () {
      // Given
      final animal = Animal();
    });

    test('when eat is called, then it should print "eating"', () {
      // Given
      final animal = Animal();
    });

    test('when breath is called, then it should print "breathing"', () {
      // Given
      final animal = Animal();
    });
  });
}
```

Esto hará que antes de cada test, tengamos una instancia de `Animal` para ejecutar sus métodos. 💀 Ya saben una forma mejor de hacer lo anterior. Van a probar?

```dart
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    // Given
    Animal animal;
    
    setUp(() {
      animal = Animal();
    });

    test('when sleep is called, then it should print "sleeping"', () {
    });

    test('when eat is called, then it should print "eating"', () {
    });

    test('when breath is called, then it should print "breathing"', () {
    });
  });
}
```

Podríamos haberlo hecho una sola vez en el `setUp` y eso nos ahora mucho código!

Fíjense ahora cómo nuestro test nos va indicando qué necesitamos: ya nos arroja un error porque dicha clase no existe. La creamos en nuestro `classes_advanced_base.dart`? Lo haremos simple: `class Animal {}`.

Ya tenemos nuestra clase y nuestros tests dejaron de fallar! Ahora que ya tenemos nuestro _Given_, vamos a implementar nuestros _When_ dentro de cada test:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    test('when sleep is called, then it should print "sleeping"', () {
      // When
      animal.sleep();
    });

    test('when eat is called, then it should print "eating"', () {
      // When
      animal.eat();
    });

    test('when breath is called, then it should print "breathing"', () {
      // When
      animal.breath();
    });
  });
}
```

Nuevo error ya que esos métodos no están implementados! Vamos a hacerlo en la clase que creamos!

```dart
class Animal {
  void sleep() => print('sleeping');
  void eat() => print('eating');
  void breath() => print('breathing');
}
```

Ya no tenemos errores! Fíjense cómo paso a paso nuestros propios tests nos guían a la implementación.

Ahora podríamos correrlos y no veríamos ningún fallo pero tampoco estaríamos testeando nada en particular. Cómo hacemos para testear lo que se imprime en nuestra consola? 😒 Existen maneras de hacerlo pero aun son muy complejas lo que nos lleva a modificar un poco nuestro código original y __ser creativos a la hora de testear, lo que es fundamental ya que en escenarios complejos no siempre las formas conocidas les van a permitir obtener los resultados esperados__.

En este caso, una forma podría ser en lugar de imprimir nuestra función, retornar una `String` que luego imprimiremos. Modifiquemos entonces nuestro test primero:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    Animal animal;
    setUp(() {
      animal = Animal();
    });
    test('when sleep is called, then it should print "sleeping"', () {
      // When
      final result = animal.sleep();
    });

    test('when eat is called, then it should print "eating"', () {
      // When
      final result = animal.eat();
    });

    test('when breathe is called, then it should print "breathing"', () {
      // When
      final result = animal.breathe();
    });
  });
}
```

Listo, aunque se nos presenta algo que jamás habíamos visto!

## Late

_The non-nullable local variable 'animal' must be assigned before it can be used. Try giving it an initializer expression, or ensure that it's assigned on every execution path._

Nos dice que `animal` debe ser asignado antes de ser utilizado ya que esto nos previene de encontrarnos con un valor nulo y romper nuestra aplicación cuando tratemos de hacer algo con él.

Lo cierto es que lo estamos haciendo ya que con el `setUp`, antes de que cada test corra, lo estamos inicializando. Sin embargo, el _system check_ de Dart no termina de poder verlo. Y esto puede ocurrir en muchas otras situaciones.

Cómo hacemos entonces? Tenemos otra _keyword_ que le dice a Dart que no se preocupe, que nosotros estamos absolutamente convencidos de que la variable `animal` va a ser inicializada.

Tenemos que tener cuidado cada vez que la utilicemos ya que si no podemos afirmar que la variable en cuestión va a ser inicializada en cada uno de los casos, corremos un alto riesgo de romper todo! 🤣 Procedamos a introducirla al comienzo de la línea y veamos como los errores ahora cambian:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    test('when sleep is called, then it should print "sleeping"', () {
      // When
      final result = animal.sleep();
    });

    test('when eat is called, then it should print "eating"', () {
      // When
      final result = animal.eat();
    });

    test('when breathe is called, then it should print "breathing"', () {
      // When
      final result = animal.breathe();
    });
  });
}
```

Listo, no tenemos errores mas solo un aviso de que `result` no está siendo utilizado. Pero... 🤨 deberíamos tener errores! 💀 Vayan a elucubrarlo ustedes!

Ya se dieron cuenta qué sucedió? Exacto! Estamos escribiendo de forma poco precisa nuestro código porque la variable `result` se adapta al resultado ya que no le establecimos un tipo pero nosotros necesitamos un tipo específico para luego utilizar en los `print`. 💀 Qué tipo necesitamos? Esta fue la pista número dos por si no lo descubrieron en el párrafo anterior.

Vamos entonces, a ponernos más firmes:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    test('when sleep is called, then it should print "sleeping"', () {
      // When
      final String result = animal.sleep();
    });

    test('when eat is called, then it should print "eating"', () {
      // When
      final String result = animal.eat();
    });

    test('when breathe is called, then it should print "breathing"', () {
      // When
      final String result = animal.breathe();
    });
  });
}
```

Ahora sí van a ver que falla ya que cada una de las expresiones en las funciones que estamos llamando retorna `void` cuando ahora le estamos pidiendo una `String` en su lugar. Una vez más, esto nos guía a cómo seguir. 💀 Vayan a hacer la tarea! 🤣

Modificaremos entonces nuestros métodos para retornar `String`s:

```dart
class Animal {
  String sleep() => 'sleeping';
  String eat() => 'eating';
  String breath() => 'breathing';
}
```

Ya tenemos nuestros tests sin errores aunque tuvimos que cambiar lo que queríamos lograr con nuestra aplicación: queríamos que imprima pero ahora necesitamos poder testarlo por lo que le pedimos que retorne esa palabra, además de imprimirla.

Recuerden que ésta, es una práctica solo a los fines de empezar a aprender cuestiones más avanzadas sobre clases y porque aun no tenemos todos los conocimientos para testear qué imprimimos en la consola. En la vida real no tenemos que cambiar la funcionalidad para poder testear, a no ser que la nueva funcionalidad satisfaga los mismos objetivos que la función anterior.

Vamos entonces a cambiar nuestras funciones para retornar una `String` además de imprimir el valor y también cambiar entonces, las descripciones de nuestros tests:

```dart
class Animal {
  String sleep() {
    const String sleepingString = 'sleeping';
    print(sleepingString);
    return sleepingString;
  }

  String eat() {
    const String eatingString = 'eating';
    print(eatingString);
    return eatingString;
  }

  String breath() {
    const String breathingString = 'breathing';
    print(breathingString);
    return breathingString;
  }
}
```

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    // we avoid printing for now
    test('when sleep is called, then it should return & (print) "sleeping"',
        () {
      // When
      final result = animal.sleep();
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "eating"', () {
      // When
      final result = animal.eat();
    });

    // we avoid printing for now
    test('when breathe is called, then it should return & (print) "breathing"',
        () {
      // When
      final result = animal.breath();
    });
  });
}
```

Perfecto! No es una maravilla? 😍 Solo nos quedan los _Then_ con sus respectivos `expect`. 💀 Qué tal si prueban ustedes primero?

He aquí el test final:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    // we avoid printing for now
    test('when sleep is called, then it should return & (print) "sleeping"',
        () {
      // When
      final result = animal.sleep();

      // Then
      expect(result, 'sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "eating"', () {
      // When
      final result = animal.eat();

      // Then
      expect(result, 'eating');
    });

    // we avoid printing for now
    test('when breathe is called, then it should return & (print) "breathing"',
        () {
      // When
      final result = animal.breath();

      // Then
      expect(result, 'breathing');
    });
  });
}
```

Y esto lo que deberían ver en la consola cuando ejecutado: primero los `print` antes de cada test y luego el test en cuestión.

```shell
sleeping
✓ Given an Animal class, when sleep is called, then it should return & (print) "sleeping"
eating
✓ Given an Animal class, when eat is called, then it should return & (print) "eating"
breathing
✓ Given an Animal class, when breathe is called, then it should return & (print) "breathing"
Exited
```
