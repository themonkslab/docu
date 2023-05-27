---
sidebar_position: 4
---

# Override

Continuando con el código anterior, voy a instanciar dos clases y llamar a `eat` en cada una de ellas. El código que utilizo es el siguiente y luego les dejo el _output_ que se puede ver al correrlo:

```dart
import 'package:classes_advanced/classes_advanced.dart';

void main() {
  final animal = Animal(scientificName: 'Animalus');
  final dog = Dog(scientificName: 'Perrus');

  animal.eat();
  dog.eat();
}
```

```shell
🥩 eating
🥩 eating
Exited
```

Cómo sabemos cuál pertenece a `Animal` y cuál a `Dog`? Qué les parece si en nuestros tests hacemos algo que nos diferencie a una clase con la otra? 💀 Se animan a experimentar un poco?

Solamente les voy a dejar el test referido a ello de la clase `Dog`; ello sería suficiente para diferenciarlas:

```dart
  test(
        'when eat is called, then it should return & (print) "I am a Dog! I am 🥩 eating"',
        () {
      // When
      final result = dog.eat();

      // Then
      expect(result, 'I am a Dog! I am 🥩 eating');
    });
```

En este test, quiero lograr que la clase `Dog` se diferencie de su clase padre `Animal` cuando llame al método `eat`. Ya tengo entonces el test y de momento, está fallando. Cómo hago para implementar este cambio?

Cuando extendemos una clase, la _subclass_ utiliza los métodos de su padre tal y como dicha _superclass_ los creó. Sin embargo podemos sobreescribir (_override_) dichos métodos para indicar en la subclase un comportamiento diferente al de la superclase:

```dart
class Dog extends Animal {
  Dog({required String scientificNamev}) : super(scientificName: scientificName);

  String eat() => 'I am a Dog! I am 🥩 eating';


  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}
```

Si hacemos esto y corremos nuestro test, podríamos ver que ya no falla aunque Dart nos pide amablemente, que 'anotemos' aquellos métodos que sobreescribimos. 'Anotar'? Sí, y ustedes ya lo vienen haciendo.

En Dart, las anotaciones (también conocidas como metadatos) son objetos que se pueden agregar a clases, métodos, variables y otros elementos, para proporcionar información adicional y metadatos. Las anotaciones se escriben utilizando la sintaxis @nombreDeLaAnotacion y se colocan justo antes del elemento de programación al que se aplican.

Las anotaciones se pueden usar para muchos propósitos diferentes, como:

- Proporcionar información adicional sobre cómo se debe procesar un elemento de programación
- Especificar que un elemento de programación es obsoleto o no se debe usar
- Indicar cómo se debe serializar o deserializar un objeto
- Especificar que un método o función debe ser un punto de entrada para la aplicación

Dart proporciona varias anotaciones predefinidas, como `@deprecated`, `@override`, `@required`, `@immutable` y muchas más.

En este caso, bastaría con agregar `@override` en la línea anterior a la que declaramos nuestro sobreescritura:

```dart
class Dog extends Animal {
  Dog({required String scientificName}) : super(scientificName: scientificName);

  @override
  String eat() {
    const String eatingString = 'I am a Dog! I am 🥩 eating';
    print(eatingString);
    return eatingString;
  }

  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}
```

Ahora, si volvemos a correr nuestro código, podemos observar el resultado esperado:

```shell
🥩 eating
I am a Dog! I am 🥩 eating
Exited
```

## Llamar a un método con `super`

Podríamos también querer llamar en la _subclass_, al método de la clase padre y luego agregar algún otro comportamiento. Vamos a intentarlo con el método `sleep` y para ello, obviamente, empezamos desde los tests.

Vayan nuevamente al _group_ de la clase `Dog`. Lo que quiero lograr es que cuando desde esta clase llamemos al método `sleep`, primero llame al mismo método de la _superclass_ pero luego agregue lo siguiente: "I\'m a dog and I ❤️ to sleep!". Si corren lo siguiente, debería fallarles:

```dart
   test('when sleep is called, then it should return & (print) "💤 sleeping. I\'m a dog and I ❤️ to sleep!"',
        () {
      // When
      final result = dog.sleep();

      // Then
      expect(result, '💤 sleeping. I\'m a dog and I ❤️ to sleep!');
    });
```

Cómo podríamos solucionarlo en nuestra clase? Primero que nada, tenemos que sobreescribir el método y luego agregar nuestra funcionalidad:

```dart
  @override
  String sleep() {
    const String sleepingString = '💤 sleeping. I\'m a dog and I ❤️ to sleep!';
    print(sleepingString);
    return sleepingString;
  }
```

Van a ver que ya no falla. Sin embargo, yo quería enseñarles otra cosa!

Imaginemos que la clase `Animal` tiene una variable privada a la que no podemos acceder y que el método `sleep` hace uso de esta variable:

```dart
class Animal {
  const Animal({required this.scientificName});
  final String scientificName;

  final String _secretVariable = 'I am a secret!';
  String sleep() {
    final String sleepingString = '💤 sleeping. $_secretVariable';
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

De esta forma, ahora no podríamos de ninguna manera tratar de imitar la clase padre; estaríamos obligados a llamar a su método y luego hacer lo que queramos con el nuestro. Vamos a testear primero:

```dart
    test(
        'when sleep is called, then it should return & (print) "I\'m a dog and I ❤️ to sleep!, after calling super.sleep that has secrets!"',
        () {
      // When
      final result = dog.sleep();

      // Then
      expect(result, 'I\'m a dog and I ❤️ to sleep!');
    });
```

En este caso, no podemos saber qué va a ser lo que imprima la clase padre porque supuestamente utiliza ciertos valores secretos! 😯

Para ello, utilizamos la palabra `super` para nombrar a la clase padre llamando al método que queramos y luego hacer lo que queramos a continuación:

```dart
class Dog extends Animal {
  Dog({required super.scientificName});

  @override
  String eat() {
    const String eatingString = 'I am a Dog! I am 🥩 eating';
    print(eatingString);
    return eatingString;
  }

  @override
  String sleep() {
    super.sleep();
    const String sleepingString = 'I\'m a dog and I ❤️ to sleep!';
    print(sleepingString);
    return sleepingString;
  }

  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}
```

Tengan en cuenta que algunos ejemplos no son lo realistas que querríamos pero quiero mantener las cosas simples para que podamos aprender no solamente el tópico en cuestión (en este caso el `@override`) sino también hacerlo incorporando más y más el testing al proceso.
