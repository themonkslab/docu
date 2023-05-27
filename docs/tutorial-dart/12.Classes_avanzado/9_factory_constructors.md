---
sidebar_position: 9
---

# Factory constructors

En el capítulo previo, hablamos de hacer un _request_ a un servidor verdad? Imaginemos entonces que tenemos una aplicación que va a realizar varios de estos _request_ a una misma _API_.

Por ejemplo, podríamos en un momento hacer un _request_ para traer una película con sus detalles por su nombre. Eso lo haríamos a __un _endpoint_ o punto final__ de una comunicación que __es un punto de entrada o salida de datos en la _API_ que se utiliza para enviar o recibir información.__

En otro momento, querríamos traer las 10 películas más vistas de la historia y eso lo haríamos a otro _endpoint_. Y finalmente podríamos querer todas las películas que salieron en el último año; otro _endpoint_ y tiene la forma de una _url_, en donde tenemos una _apiUrl_ que es la _url_ de la _API_ (`https://api.example.com`) y el _endpoint_ que se anexa a la base (`v1/products/`). Todo se vería: `https://api.example.com/v1/products/`.

Sin embargo, todas estas llamadas, peticiones o _requests_ compartirían una misma serie de configuraciones y sería muy útil poder tenerlas agrupadas en una clase. También sería óptimo para nuestra aplicación el instanciar esta clase una sola vez y no que tenga que estar instanciando clases diferentes cada vez quenecesito estas configuraciones. Veámoslo mejor en un ejemplo.

Vamos a crear una clase `AppConfig` que tenga la dirección de la _API_ a la que vamos a llamar. A esta _baseUrl_ le tendríamos luego que ir agregando los _endpoints_ particulares según lo que vamos necesitando.

También tendrá un campo que represente si va a utilizar _HTTPS_ (_Hypertext Transfer Protocol Secure_ o protocolo de hypertexto de transferencia segura), un protocolo de comunicación que se utiliza para proteger la información que se intercambia en internet y es una versión más segura del protocolo _HTTP_ que se utiliza para transmitir datos. Este último lo setearemos por defecto en `true`.

```dart
class AppConfig {
  final String apiUrl;
  final bool useHttps;

  AppConfig({
    required this.apiUrl,
    this.useHttps = true,
  });
}
```

Luego, supongamos que necesitamos esta configuración en tres lugares distintos de nuestra aplicación. En cada lugar, llamaríamos a la clase y la instanciaríamos. Ahora para achicar el ejemplo, vamos a instanciarlas en el mismo lugar. Luego de eso vamos a chequear mediante _assertions_ que se trate de instancias distintas pero que en realidad cuentan con el mismo contenido.

```dart
void main() {
  // primer lugar de uso
  final config1 = AppConfig(apiUrl: 'https://example.com', useHttps: true);
  // segundo lugar de uso
  final config2 = AppConfig(apiUrl: 'https://example.com', useHttps: true);
  // tercer lugar de uso
  final config3 = AppConfig(apiUrl: 'https://example.com', useHttps: true);

  assert(!identical(config1, config2));
  assert(!identical(config2, config3));

  assert(config1.apiUrl == 'https://example.com');
  assert(config2.apiUrl == 'https://example.com');
  assert(config3.apiUrl == 'https://example.com');

  assert(config1.useHttps);
  assert(config2.useHttps);
  assert(config3.useHttps);
}
```

Al correrlo solo vemos `Exited` dado que las _assertions_ dieron todas `true` lo que demuestra que creamos instancias distintas pero con los mismos valores, consumiendo recursos de manera innecesaria. Desde otro punto de vista, si las _assertions_ habrían comprobado que los valores entre una instancia y las otras eran diferentes entonces nos habríamos equivocado y tendríamos por consecuencia un fallo en nuestros _requests_.

De esta forma, vemos que __sería mucho más útil tener una clase que sea siempre la misma cada vez que se la instancie, evitando los errores y optimizando los procesos.__

## Factory Constructor

__Crearemos una clase que va a devolver la misma instancia cada vez que se la llame__ y vamos a explicar ese proceso paso por paso. Lo primero que tenemos que entender es que necesitamos un _factory constructor_ o constructor de fábrica.

Un _factory constructor_ es útil __cuando queremos personalizar el proceso de creación de una instancia de una clase__, en lugar de simplemente devolver una nueva instancia cada vez que se llama al constructor.

__En este caso, nos permite controlar la instancia única de la clase y garantizar que solo haya una instancia disponible.__ El factory constructor __puede verificar si ya existe una instancia y devolver esa instancia en lugar de crear una nueva__.

Vamos a explicar todo en el ejemplo con comentarios:

```dart
class AppConfig {
  // Los campos que teníamos antes y necesitamos para nuestra clase
  final String apiUrl;
  final bool useHttps;

  // Un constructor privado para que no se pueda crear una instancia de
  // AppConfig
  // Desde afuera, no pueden llamar a AppConfig._internal()
  AppConfig._internal({
    required this.apiUrl,
     this.useHttps = true,
  });
}
```

Ahora agregaremos una variable que va a guardar internamente la instancia de la clase:

```dart
class AppConfig {
  // Un campo estático que almacena la instancia de la clase
  static AppConfig? _instance;

  // Los campos que teníamos antes y necesitamos para nuestra clase
  final String apiUrl;
  final bool useHttps;

  // Un constructor privado para que no se pueda crear una instancia de
  // AppConfig
  // Desde afuera, no pueden llamar a AppConfig._internal()
  AppConfig._internal({
    required this.apiUrl,
    this.useHttps = true,
  });
}
```

La razón por la cual `_instance` es `static` es para asegurarse de que sólo haya una instancia de una clase particular en el programa. Si la variable `_instance` no fuera `static`, cada vez que se crea una nueva instancia de la clase `AppConfig`, se crearía una nueva variable `_instance` para esa instancia específica. Como resultado, no se estaría garantizando que haya sólo una instancia de la clase en el programa.

Sin embargo, lo anterior es solo posible si inyectamos la última parte! Ahora viene la magia! Vamos a crear un `factory constructor` que va a recibir los parámetros como cualquier otro constructor y va a chequear primero si `_instance` ya tiene guardada dentro una instancia de la clase (si no es `null`); si no la tiene, instancia en ella una clase utilizando `AppConfig._internal` con los parámetros que el mismo constructor recibió para finalmente retornar la variable `_instance`:

```dart
  factory AppConfig({required String apiUrl, required bool useHttps}) {
    // Si no existe una instancia, creamos una
    if (_instance == null) {
      _instance = AppConfig._internal(
        apiUrl: apiUrl,
        useHttps: useHttps,
      );
    }

    // Devolvemos la instancia
    return _instance!;
  }
```

Y lo anterior, podríamos resolverlo de forma más concisa y elegante:

```dart
  factory AppConfig({required String apiUrl, required bool useHttps}) {
    // Si no existe una instancia, creamos una
    _instance ??= AppConfig._internal(
      apiUrl: apiUrl,
      useHttps: useHttps,
    );

    // Devolvemos la instancia
    return _instance!;
  }
```

Todo junto se vería así:

```dart
class AppConfig {
  // Un campo estático que almacena la instancia de la clase
  static AppConfig? _instance;

  // Los campos que teníamos antes y necesitamos para nuestra clase
  final String apiUrl;
  final bool useHttps;

  factory AppConfig({required String apiUrl, required bool useHttps}) {
    // Si no existe una instancia, creamos una
    _instance ??= AppConfig._internal(
      apiUrl: apiUrl,
      useHttps: useHttps,
    );

    // Devolvemos la instancia
    return _instance!;
  }

  // Un constructor privado para que no se pueda crear una instancia de
  // AppConfig
  // Desde afuera, no pueden llamar a AppConfig._internal()
  AppConfig._internal({
    required this.apiUrl,
    this.useHttps = true,
  });
}
```

Prueben ahora qué pasa si corren su `main`! Exacto! Falla la primer _assertion_ debido a que de hecho, sí son idénticas! 💀 Qué tienen que cambiar en las _assertions_ para que ya no fallen y se compruebe que estamos hablando siempre de la misma instancia?

```dart
void main() {
  final config1 = AppConfig(apiUrl: 'https://example.com', useHttps: true);
  final config2 = AppConfig(apiUrl: 'https://example.com', useHttps: true);
  final config3 = AppConfig(apiUrl: 'https://example.com', useHttps: true);

  assert(identical(config1, config2));
  assert(identical(config2, config3));

  assert(config1.apiUrl == 'https://example.com');
  assert(config2.apiUrl == 'https://example.com');
  assert(config3.apiUrl == 'https://example.com');

  assert(config1.useHttps);
  assert(config2.useHttps);
  assert(config3.useHttps);
}
```

## Singleton pattern

Esto que acabamos de implementar recibe el nombre de _Singleton pattern_. Pero primero vamos a explicar qué es un _pattern_ o patrón!

__Un patrón de diseño (_pattern_) es una solución general para un problema común.__ Es decir, __es una manera de resolver un problema que ha sido probada y documentada para ser eficaz y eficiente__.

Por otro lado, __el patrón Singleton es un patrón de diseño que garantiza que una clase solo tenga una instancia y proporciona un punto de acceso global a esa instancia.__ Esto es útil en situaciones en las que una única instancia de una clase necesita coordinar acciones en todo el sistema, como por ejemplo la relación con una _API_ en particular.

## Otros casos de uso de Factory Constructors

### Clases con varias formas de inicialización

A veces queremos crear una clase que se pueda inicializar de diferentes formas, pero no queremos crear diferentes constructores para cada forma de inicialización. En este caso, podemos utilizar un _factory constructor_ que acepte diferentes parámetros y que decida qué tipo de objeto debe retornar.

```dart
class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  factory Person.fromName(String name) {
    return Person(name: name, age: 0);
  }

  factory Person.fromAge(int age) {
    return Person(name: '', age: age);
  }
}
```

En este ejemplo, podemos crear una persona utilizando el constructor normal `Person(name: 'John', age: 30)`, pero también podemos crear una persona utilizando el constructor `Person.fromName('John')`, que crea una persona con el nombre 'John' y la edad 0, o el constructor `Person.fromAge(30)`, que crea una persona sin nombre y con la edad 30.

### Clases que implementan una interfaz

A veces queremos que una clase se comporte como otra clase o interfaz, pero la clase base o interfaz no tiene un constructor adecuado. En este caso, podemos utilizar un factory constructor que cree una instancia de una subclase que implemente la interfaz o herede de la clase base.

```dart
abstract class Animal {
  void speak();
}

class Cat implements Animal {
  void speak() {
    print('Meow!');
  }

  factory Cat.fromKitten() {
    return Kitten();
  }
}

class Kitten extends Cat {
  void speak() {
    print('Mew!');
  }
}
```

En este ejemplo, creamos una clase `Cat` que implementa la interfaz `Animal`. También creamos una subclase `Kitten` que hereda de `Cat` y que sobrescribe el método `speak`. Utilizamos un _factory constructor_ en la clase `Cat` que crea una instancia de `Kitten`. De esta forma, podemos crear un gatito utilizando el constructor `Cat.fromKitten()` en lugar de crear una instancia de Kitten directamente.

Además, si se instancia directamente un objeto de la clase `Kitten`, se estaría violando el __principio de responsabilidad única, ya que la clase `Kitten` estaría asumiendo la responsabilidad de crear instancias de sí misma y también de convertir instancias de la clase `Cat` en instancias de `Kitten`__. Al utilizar un factory constructor en la clase `Kitten`, se delega la responsabilidad de la creación de instancias a la propia clase y se evita la violación del principio de responsabilidad única. Ya trabajaremos más en este concepto!

### Convertir JSONs

Tenemos aun otro ejemplo pero es lo suficientemente importante como para ponerlo en un artículo separado, el siguiente!
