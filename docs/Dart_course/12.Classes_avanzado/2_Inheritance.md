---
sidebar_position: 2
---

# Inheritance o Herencia

Vamos a utilizar el último ejemplo y partir de allí. Copien el paquete/carpeta `classes_advanced`; vamos a trabjar con él.

En ese paquete, hemos creado una clase `Animal`, la testeamos, pero aun no la utilizamos. Para ello lo que vamos a hacer es en nuestro `classes_advanced_example.dart`, vamos a crear una instancia de dicha clase y vamos a llamar a uno de sus métodos:

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final animal = Animal();
  animal.eat();
}
```

En consola deberíamos ver esto:

```shell
🥩 eating
Exited
```

Ah! Le sumé un emoji a cada función para hacerla más divertida! 😅 __Más allá de lo divertida, utilizar emojis en la consola puede serles muy útil para encontrar elementos con mayor rapidez__ ya que es más fácil encontrar una imagen a tener que entender un concepto. 💀 Claramente, es algo que ustedes van a hacer ahorita mismo!

Qué sucedería si quisiéramos crear un perro? Hace exactamente las mismas cosas que nuestra clase `Animal` solo que además, va a ladrar. Qué podemos hacer? __Podríamos utilizar los métodos de `Animal` y agregar otros en nuestro futuro `Dog`__ ('Perro en inglés')?

__Podemos hacerlo utilizando la _keyword_ `extends` que extiende la funcionalidades de una clase, convirtiéndola a esta última en la clase padre.__

Así __podríamos pensar a nuestra clase__ `Dog`, __como hija de nuestra clase `Animal`__:

```dart
Animal
└── Dog
```

Lo haríamos de esta manera, agregando el método `bark`, ladrar:

```dart
class Animal {
  String sleep() {
    const String sleepingString = '💤 sleeping';
    print(sleepingString);
    return sleepingString;
  }

  String eat() {
    const String eatingString = '🥩 eating';
    print(eatingString);
    return eatingString;
  }

  String breath() {
    const String breathingString = '💨 breathing';
    print(breathingString);
    return breathingString;
  }
}

class Dog extends Animal {
  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}
```

Y luego entonces podemos hacer lo siguiente:

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final animal = Animal();
  animal.eat();
  final dog = Dog();
  dog.bark();
  dog.eat();
  dog.sleep();
  dog.breath();
}
```

Si corremos dicho programa, podríamos ver en la terminal:

```shell
🥩 eating
🐶 barking
🥩 eating
💤 sleeping
💨 breathing
Exited
```

Pero estamos seguros de que `Dog` está llamando a `Animal`? Tenemos dos maneras de poner claridad en el asunto. Vamos con la primera:

```dart
class Animal {
  String sleep() {
    const String sleepingString = '💤 The animal is sleeping';
    print(sleepingString);
    return sleepingString;
  }

  String eat() {
    const String eatingString = '🥩 The animal is eating';
    print(eatingString);
    return eatingString;
  }

  String breath() {
    const String breathingString = '💨 The animal is breathing';
    print(breathingString);
    return breathingString;
  }
}

class Dog extends Animal {
  String bark() {
    const String barkingString = '🐶 The dog is barking';
    print(barkingString);
    return barkingString;
  }
}
```

No es la más bella pero podemos verlo más claramente ahora? La verdad es que yo no me quedo tranquilo hasta que haga un test. 💀 Borren el código de recién y vayan a ver si pueden testear de que su `Dog` efectivamente puede llamar a los métodos de su `Animal`.

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
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = animal.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = animal.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = animal.breath();

      // Then
      expect(result, '💨 breathing');
    });
  });

  group('Given a Dog class', () {
    //Given
    late Dog dog;
    setUp(() {
      dog = Dog();
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = dog.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = dog.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = dog.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when bark is called, then it should return & (print) "🐶 barking"',
        () {
      // When
      final result = dog.bark();

      // Then
      expect(result, '🐶 barking');
    });
  });
}
```

Notaron cómo utilicé el `group`? Nos permite ser claros y dividir aquellos tests destinados a la clase `Animal` y aquellos destinados a la clase `Dog`. Ahora sí podemos estar seguros de que cada clase hace lo que corresponde y que `Dog` puede utilizar los métodos de su clase padre. Esto debieran ver cuando corren sus tests:

```shell
💤 sleeping
✓ Given an Animal class, when sleep is called, then it should return & (print) "💤 sleeping"
🥩 eating
✓ Given an Animal class, when eat is called, then it should return & (print) "🥩 eating"
💨 breathing
✓ Given an Animal class, when breathe is called, then it should return & (print) "💨 breathing"
💤 sleeping
✓ Given a Dog class when sleep is called, then it should return & (print) "💤 sleeping"
🥩 eating
✓ Given a Dog class when eat is called, then it should return & (print) "🥩 eating"
💨 breathing
✓ Given a Dog class when breathe is called, then it should return & (print) "💨 breathing"
🐶 barking
✓ Given a Dog class when bark is called, then it should return & (print) "🐶 barking"
Exited
```

__Esto se llama _subclassing_ o _inheritance_ ya que la clase `Dog` hereda los métodos de su clase padre `Animal`.__

Muchos de ustedes dirán 'pero yo convivo con un gato, no un perro' y pueden estar en lo cierto. 💀 Vayan a implementar la clase `Cat`, ☝🏼 pero comiencen con el test.

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
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = animal.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = animal.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = animal.breath();

      // Then
      expect(result, '💨 breathing');
    });
  });

  group('Given a Dog class', () {
    //Given
    late Dog dog;
    setUp(() {
      dog = Dog();
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = dog.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = dog.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = dog.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when bark is called, then it should return & (print) "🐶 barking"',
        () {
      // When
      final result = dog.bark();

      // Then
      expect(result, '🐶 barking');
    });
  });

  group('Given a Cat class', () {
    //Given
    late Cat cat;
    setUp(() {
      cat = Cat();
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = cat.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = cat.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = cat.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when meow is called, then it should return & (print) "🐱 meowing"',
        () {
      // When
      final result = cat.meow();

      // Then
      expect(result, '🐱 meowing');
    });
  });
}
```

```dart
class Animal {
  String sleep() {
    const String sleepingString = '💤 sleeping';
    print(sleepingString);
    return sleepingString;
  }

  String eat() {
    const String eatingString = '🥩 eating';
    print(eatingString);
    return eatingString;
  }

  String breath() {
    const String breathingString = '💨 breathing';
    print(breathingString);
    return breathingString;
  }
}

class Dog extends Animal {
  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}

class Cat extends Animal {
  String meow() {
    const String meowingString = '🐱 meowing';
    print(meowingString);
    return meowingString;
  }
}
```

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final animal = Animal();
  animal.eat();
  final dog = Dog();
  dog.bark();
  dog.eat();
  dog.sleep();
  dog.breath();
  final cat = Cat();
  cat.meow();
}
```

```shell
🥩 eating
🐶 barking
🥩 eating
💤 sleeping
💨 breathing
🐱 meowing
Exited
```

Muy bien! 🤙 Pero qué tal si su compañero gatuno o perruno fue enviado desde algún planeta extraño y además de todo lo anterior, pudiera también tirar rayos X desde sus ojos! 🦸‍♀️ Habría que crear una clase que extienda `Animal` o __podríamos extender una clase como `Dog` que extienda a su vez `Animal` y tener entonces lo particular de esta nueva clase llamada `SuperDog`, las funciones de `Dog` y las de `Animal`?__

## 💪 Creando nuestro perro dinamita 🧨

__Requirement__: crear una clase `SuperDog`, instanciarla y probarla. Para todo lo anterior, empezar desde los tests.

---

__💀 Solución*__:

*Solo pego el nuevo código para ocupar menos espacio.

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
    group('Given a SuperDog class', () {
    //Given
    late SuperDog superDog;
    setUp(() {
      superDog = SuperDog();
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = superDog.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = superDog.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = superDog.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when bark is called, then it should return & (print) "🐶 barking"',
        () {
      // When
      final result = superDog.bark();

      // Then
      expect(result, '🐶 barking');
    });

    test(
        'when throwXRay is called, then it should return & (print) "🥽 throwing X-Ray - Cyclops is my little brother! 🤣"',
        () {
      // When
      final result = superDog.throwXRay();

      // Then
      expect(result, '🥽 throwing X-Ray - Cyclops is my little brother! 🤣');
    });
  });
}
```

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final superDog = SuperDog();
  superDog.throwXRay();
}
```

```dart
class SuperDog extends Dog {
  String throwXRay() {
    const String throwingXRayString =
        '🥽 throwing X-Ray - Cyclops is my little brother! 🤣';
    print(throwingXRayString);
    return throwingXRayString;
  }
}
```

```shell
💤 sleeping
✓ Given a SuperDog class when sleep is called, then it should return & (print) "💤 sleeping"
🥩 eating
✓ Given a SuperDog class when eat is called, then it should return & (print) "🥩 eating"
💨 breathing
✓ Given a SuperDog class when breathe is called, then it should return & (print) "💨 breathing"
🐶 barking
✓ Given a SuperDog class when bark is called, then it should return & (print) "🐶 barking"
🥽 throwing X-Ray - Cyclops is my little brother! 🤣
✓ Given a SuperDog class when throwXRay is called, then it should return & (print) "🥽 throwing X-Ray - Cyclops is my little brother! 🤣"
Exited
```

