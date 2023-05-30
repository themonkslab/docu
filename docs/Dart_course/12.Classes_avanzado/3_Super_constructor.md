---
sidebar_position: 3
title: 3. Super constructor
---

# Super constructor

@Mau Di Bert

Lamento decirles que hasta el momento estuvimos aplicando poco rigor científico a lo que fuimos realizando: cómo puede ser que tengamos animales, perros, gatos y hasta super perros, sin que posean un nombre científico!? 😝

Vayamos a los tests y dentro del grupo referido a nuestra clase `Animal`, vamos a crear otro test con la siguiente descripción: 'when "scientificName" is called, then it should return a String'.

Ya que hicieron la descripción, podrían hacer el test no es verdad? 💀 Vayan a intentarlo ustedes!

Así lo hice yo:

```dart
    test('when "scientificName" is called, then it should return a String', () {
      // When
      final result = animal.scientificName;

      // Then
      expect(result, isA<String>());
    });
```

Utilizando uno de los _matchers_ que vimos superficialmente antes. Sí, es probable que se hayan roto un poquito las neuronas pero esa es la mejor forma de aprender! 😋

__Qué es lo que hace este `isA<Type>()` _matcher_? Ejecuta una función que chequea si el resultado o el primer parámetro del `expect`, es del `Type` que le pasamos al _matcher_.__

Una vez con el test realizado podríamos ir a `Animal` y agregarlo:

```dart
class Animal {
  final String scientificName;

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
```

Pero eso nos arroja un error ya que dicha variable tiene que inicializarse. Ustedes ya saben cómo hacer eso: utilizando un constructor. 💀 Una vez más, tomen el camino del zen y vayan a intentarlo.

Espero que lo hayan intentado a mano, escribiéndolo ustedes o sino, también espero que se hayan acordado de hacer `cmd + click` en el error y eso les haya dado la posibilidad de crear automáticamente el constructor! 😗

Genial! Ya tenemos el constructor... Oups! Me olvidé de pegárselos:

```dart
class Animal {
  const Animal({required this.scientificName});
  final String scientificName;

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
```

Lo que sucede es que esto nos tira un error en todas las otras clases salvo en `SuperDog`.

El error dice que la _superclass_ `Animal` no tiene un constructor sin argumentos o lo que es lo mismo que un constructor con 0 argumentos. Sin embargo, nuestra clase `Animal` sí tiene un constructor. Cómo se puede entender esto?

Cuando una subclase es creada lo primero que hace es llamar al constructor de su padre. Lo que sucede es que lo está llamando pero el constructor de la clase padre, `Animal`, es un constructor que requiere de un argumento y no se lo estamos pasando. Dart sabiamente nos previene señalando el error. La clase padre o _superclass_, espera dicho argumento.

Podríamos para corroborarlo, hacer _nullable_ el _field_ que agregamos recién y quitarle el `required` del constructor y van a ver que dicho error desaparece.

```dart
class Animal {
  const Animal({ this.scientificName});
  final String? scientificName;

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

class SuperDog extends Dog {
  String throwXRay() {
    const String throwingXRayString =
        '🥽 throwing X-Ray - Cyclops is my little brother! 🤣';
    print(throwingXRayString);
    return throwingXRayString;
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

Pero claramente eso no es lo que queremos, por lo que vuelvan el código al estado anterior.

Lo que tenemos que hacer entonces, es crear un constructor para cada una de las clases y que dicho constructor llame a la clase padre.

Si se paran en la clase `Dog` por ejemplo, y presionan `cmd + .`, tenemos un comando que nos permite crear un constructor para llamar a la _superclass_. Presiónenlo y van a ver que nos crea un constructor que ya require también del _field_ `scientificName`:

```dart
class Dog extends Animal {
  Dog({required super.scientificName});

  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}
```

Y ahora, tabién lo va a requerir nuestro `SuperDog`:

```dart
class SuperDog extends Dog {
  SuperDog({required super.scientificName});

  String throwXRay() {
    const String throwingXRayString =
        '🥽 throwing X-Ray - Cyclops is my little brother! 🤣';
    print(throwingXRayString);
    return throwingXRayString;
  }
}
```

Y claramente, lo mismo con `Cat`:

```dart
class Cat extends Animal {
  Cat({required super.scientificName});

  String meow() {
    const String meowingString = '🐱 meowing';
    print(meowingString);
    return meowingString;
  }
}
```

Ahora nos quedaría actualizar nuestros tests...:

```dart
import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal(scientificName: 'Animalus');
    });

    test('when "scientificName" is called, then it should return a String', () {
      // When
      final result = animal.scientificName;

      // Then
      expect(result, isA<String>());
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
      dog = Dog(scientificName: 'Perrus');
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
      cat = Cat(scientificName: 'Gatitus');
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

  group('Given a SuperDog class', () {
    //Given
    late SuperDog superDog;
    setUp(() {
      superDog = SuperDog(scientificName: 'SuperPerrus');
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

Y si quisiéramos para probar, cuando efectivamente hacemos uso de la clase:

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final animal = Animal(scientificName: 'Animalus');
  print(animal.scientificName);
}
```

## Pequeña aclaración retroactiva

Es muy probable, que vean código escrito diferente a como lo acaban de hacer, llamando al método `super` en la _initialization list_ del constructor de la _subclass_. Esto es porque esta era la forma previa de pasarle a la clase _super_ sus argumentos. Por ello, es importante que lo sepan y puedan ver aquí así saben de qué se trata:

```dart
  Dog({required String scientificName}) : super(scientificName: scientificName);
```

En ese caso, se hacía explícito el llamado a la _superclass_; ahora contamos con el _shorthand_ que ya vimos.

Es interesante conocer formas previas si como en este caso, dejan un poquito más en evidencia el proceso y además, aun no están lo suficientemente actualizadas en mucha cantidad de ejemplos que encuentren por allí.
