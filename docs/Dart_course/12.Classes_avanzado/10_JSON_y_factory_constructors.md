---
sidebar_position: 10
---

# JSON y Factory Constructors

En el capítulo anterior vimos de qué maneras podemos utilizar este tipo de constructores pero dejamos afuera un caso de uso extremadamente frecuente por lo que nos vamos a tomar todo un artículo para ello! Empecemos!

## JSON

_JSON_ (_JavaScript Object Notation_ o Notación de Objeto de Javascript) es un formato de intercambio de datos ligero y legible. __Se utiliza para transmitir datos estructurados en la web y se basa en una sintaxis de objetos, listas o mapas anidados__, donde los valores pueden ser cadenas, números, booleanos, objetos o listas. Es un formato muy popular para el intercambio de datos en aplicaciones web y móviles, ya que es fácil de leer y escribir para humanos y fácil de procesar para las aplicaciones.

Vamos con un ejemplo:

```json
{
  "name": "John Doe",
  "age": 30,
  "email": "johndoe@example.com",
  "address": {
    "street": "123 Main St",
    "city": "Anytown",
    "state": "CA",
    "zip": "12345"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "555-555-1212"
    },
    {
      "type": "work",
      "number": "555-555-2323"
    }
  ]
}
```

En este ejemplo, el _JSON_ representa información básica de un usuario, como su nombre, edad, dirección de correo electrónico, dirección postal y números de teléfono. La propiedad `"address"` es un objeto _JSON_ anidado que contiene la dirección del usuario, mientras que la propiedad `"phoneNumbers"` es una lista de objetos _JSON_ que representan los números de teléfono del usuario.

Este objeto en Dart se representaría con un `String` y si tuviéramos ese objeto en una variable llamada `json`, podríamos acceder a ellos utilizando la misma notación que si se tratara de un mapa, solamente necesitando de forma previa hacer una decodificación del _JSON_ original, utilizando `jsonDecode`.

### `jsonDecode`

Es una función en Dart que convierte una cadena _JSON_ en un objeto Dart. Toma una cadena _JSON_ como entrada y devuelve un objeto Dart que representa la estructura de datos descrita por la cadena _JSON_. La función es parte de la biblioteca `dart:convert`, que proporciona codificadores y decodificadores para una variedad de formatos de datos, incluyendo _JSON_.

```dart
String jsonString = '{"name":"John","age":30,"isMarried":false,"hobbies":["reading","travelling","swimming"],"address":{"street":"123 Main St","city":"New York","state":"NY","zip":"10001"}}';
Map<String, dynamic> json = jsonDecode(jsonString);
```

Luego, podríamos acceder a los valores utilizando la misma notación que si se tratara de un mapa, por ejemplo:

```dart
String name = json['name']; // John
int age = json['age']; // 30
bool isMarried = json['isMarried']; // false
List<String> hobbies = List<String>.from(json['hobbies']); // ["reading", "travelling", "swimming"]
String street = json['address']['street']; // 123 Main St
String city = json['address']['city']; // New York
```

### Volviendo a los Factory Constructors

Recordemos que en el capítulo anterior estábamos haciendo _requests_ a una _API_ sobre películas. Cuando hacemos un pedido a esta _API_, la respuesta o _response_ a ese _request_ vendría en un formato _JSON_.

Supongamos que queremos hacer una solicitud y obtener información sobre la película "El Padrino". Lo siguiente muestra cómo se verían los datos de la película "El Padrino" en formato JSON:

```json
{
  "title": "The Godfather",
  "year": 1972,
  "director": "Francis Ford Coppola",
  "rating": 9.2,
  "description": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son."
}
```

Ahora bien! Lo lógico para poder utilizar esos datos en nuestra aplicación, sería modelar una clase que represente el objeto película. 💀 Qué les parece si van a moldearla y escriben un test para ella? Pueden hacerlo todo sin la necesidad de crear todo un paquete nuevo sino utilizando uno anterior, como lo hice yo y que van a ver...

Luego de haberlo probado...

Primero ustedes! 🤣

```dart
import 'package:test/test.dart';

// void main() {
//   final simulatedResult = processRequest(returnError: true);
//   throw (simulatedResult.error!);
//   // print(simulatedResult.value is String);
// }

class Movie {
  final String title;
  final int year;
  final String director;
  final double rating;
  final String description;

  Movie({
    required this.title,
    required this.year,
    required this.director,
    required this.rating,
    required this.description,
  });
}

void main() {
  group('Given a Movie', () {
    late Movie movie;

    setUp(() {
      movie = Movie(
        title: 'The Godfather',
        year: 1972,
        director: 'Francis Ford Coppola',
        rating: 9.2,
        description:
            'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      );
    });

    test('When accessing its title, Then it should return the correct title',
        () {
      expect(movie.title, equals('The Godfather'));
    });

    test('When accessing its year, Then it should return the correct year', () {
      expect(movie.year, equals(1972));
    });

    test(
        'When accessing its director, Then it should return the correct director',
        () {
      expect(movie.director, equals('Francis Ford Coppola'));
    });

    test('When accessing its rating, Then it should return the correct rating',
        () {
      expect(movie.rating, equals(9.2));
    });

    test(
        'When accessing its description, Then it should return the correct description',
        () {
      expect(
          movie.description,
          equals(
              'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.'));
    });
  });
}
```

Ahora lo que restaría hacer es crear un _factory constructor_ en esa clase `Movie` para que cuando recibamos nuestra respuesta del servidor en formato _JSON_, introducirla como parámetro de dicho constructor y que nos devuelva un `Movie` para luego poder manejar en nuestra aplicación.

Voy a primero escribir un test para ello pero voy a crear otro grupo y así tener las cosas más ordenadas. Este grupo se va a encargar de los constructores de mi clase `Movie`:

```dart
  group(
      "Given a Movie constructor",
      () {
        test(
            'When calling Movie.fromJson with a JSON decoded file, Then it should return a Movie',
            () {
          // Esta es una JSON String
          String jsonString =
              '{ "title": "The Godfather", "year": 1972, "director": "Francis Ford Coppola", "rating": 9.2, "description": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son." }';

          // Decodificamos la JSON String y el resultado que esperamos de esta
          // decodificación es un Map<String, Object?>, es decir, un Map con
          // claves de tipo String y valores de tipo Object?
          // Porqué Object? y no Object? Porque Object? es un tipo nullable
          Map<String, Object?> json = jsonDecode(jsonString);

          // Llamamos al constructor Movie.fromJson y le pasamos el Map
          // decodificado que obtuvimos de jsonDecode
          final Movie movie = Movie.fromJson(json);

          // Verificamos que el resultado de Movie.fromJson sea una instancia de
          // Movie y que los valores de sus propiedades sean los esperados
          expect(movie, isA<Movie>());
          expect(movie.title, 'The Godfather');
          expect(movie.year, 1972);
          expect(movie.director, 'Francis Ford Coppola');
          expect(movie.rating, 9.2);
          expect(movie.description,
              'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.');
        });
      },
    );
```

Ya con un test, podemos crear el método en nuestra clase y ver si funciona correctamente:

```dart
class Movie {
  final String title;
  final int year;
  final String director;
  final double rating;
  final String description;

  Movie({
    required this.title,
    required this.year,
    required this.director,
    required this.rating,
    required this.description,
  });

  // Aquí el _factory constructor_ Movie.fromJson recibe un Map<String, dynamic>
  // al que llamaremos _json_ y luego utilizaremos este Map para construir una
  // nueva instancia de Movie.
  // Accedemos a cada uno de sus valores con la sintaxis json['key'] y
  // asignamos cada uno de estos valores a las propiedades de la nueva
  // instancia.
  // Por ejemplo, el valor de la propiedad title de la nueva instancia será
  // json['title'] y como sabemos que es una `String` podemos usar el operador
  // `as` para convertir el valor de json['title'] a `String`.
  // Lo mismo para las demás propiedades.
  factory Movie.fromJson(Map<String, Object?> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'] as int,
      director: json['director'] as String,
      rating: json['rating'] as double,
      description: json['description'] as String,
    );
  }
}
```

Qué les parece? También existe el caso en donde ustedes tengan que enviar una `Movie` a un servidor y para ello, deberían hacer el método contrario, `toJson`. 💀 Vayan a crear un test y luego implementen la función en la clase! Tengan en cuenta que ahora no necesitan retornar un `Movie` por lo que simplemente se trata de una función y no de un _factory constructor_ lo que van a crear:

```dart
      test(
          'When calling Movie.toJson with a Movie instance, Then it should return a Map<String, Object?>',
          () {
        // Creamos una instancia de Movie
        final Movie movie = Movie(
          title: 'The Godfather',
          year: 1972,
          director: 'Francis Ford Coppola',
          rating: 9.2,
          description:
              'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
        );

        // Llamamos al método toJson de la instancia de Movie y guardamos el resultado en una variable
        final Map<String, Object?> jsonMap = movie.toJson(movie);

        // Verificamos que el resultado de Movie.toJson sea una instancia de Map y que los valores sean los esperados
        expect(jsonMap, isA<Map>());
        expect(jsonMap['title'], 'The Godfather');
        expect(jsonMap['year'], 1972);
        expect(jsonMap['director'], 'Francis Ford Coppola');
        expect(jsonMap['rating'], 9.2);
        expect(jsonMap['description'],
            'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.');
      });
```

```dart

class Movie {
  final String title;
  final int year;
  final String director;
  final double rating;
  final String description;

  Movie({
    required this.title,
    required this.year,
    required this.director,
    required this.rating,
    required this.description,
  });

  // Aquí el _factory constructor_ Movie.fromJson recibe un Map<String, dynamic>
  // al que llamaremos _json_ y luego utilizaremos este Map para construir una
  // nueva instancia de Movie.
  // Accedemos a cada uno de sus valores con la sintaxis json['key'] y
  // asignamos cada uno de estos valores a las propiedades de la nueva
  // instancia.
  // Por ejemplo, el valor de la propiedad title de la nueva instancia será
  // json['title'] y como sabemos que es una `String` podemos usar el operador
  // `as` para convertir el valor de json['title'] a `String`.
  // Lo mismo para las demás propiedades.
  factory Movie.fromJson(Map<String, Object?> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'] as int,
      director: json['director'] as String,
      rating: json['rating'] as double,
      description: json['description'] as String,
    );
  }

  // Aquí el método toJson de la clase Movie retorna un `Map` del tipo `<String,
  // Object?>` que es la  representación en JSON de la instancia de Movie.
  Map<String, Object?> toJson(Movie movie) {
    return ({
      'title': movie.title,
      'year': movie.year,
      'director': movie.director,
      'rating': movie.rating,
      'description': movie.description,
    });
  }
}
```

## Qué más puede hacer un factory constructor

Qué les parece si en lugar de una _API_ que nos retorne solamente películas, dicha _API_ tiene la posibilidad de retornarnos películas y series? Podríamos crear una clase abstracta llamada `Media` y dos subclases de esta de la siguiente manera:

```dart
abstract class Media {
  final String title;
  final int year;
  final String genre;

  Media({
    required this.title,
    required this.year,
    required this.genre,
  });
}

class Movie extends Media {
  final String director;

  Movie({
    required String title,
    required int year,
    required String genre,
    required this.director,
  }) : super(
          title: title,
          year: year,
          genre: genre,
        );
}

class Serie extends Media {
  final List<String> directors;

  Serie({
    required String title,
    required int year,
    required String genre,
    required this.directors,
  }) : super(
          title: title,
          year: year,
          genre: genre,
        );
}
```

Ahora, ya que los _factory constructors_ nos permiten retornar instancias de _subclasses_ y además emplear lógicas, en nuestra clase `Media` podríamos hacer algo así:

```dart
abstract class Media {
  final String title;
  final int year;
  final String genre;

  Media({
    required this.title,
    required this.year,
    required this.genre,
  });

  // Aquí el factory constructor Media.fromJson recibe un Map<String, dynamic>
  // al que llamaremos json y luego utilizaremos este Map para construir una
  // nueva instancia de `Movie` o `Serie`.
  // Accedemos a cada uno de sus valores con la sintaxis json['key'] y
  // asignamos cada uno de estos valores a las propiedades de la nueva
  // instancia.
  // Por ejemplo, el valor de la propiedad `title` de la nueva instancia será
  // json['title'] y como sabemos que es una `String` podemos usar el operador
  // `as` para convertir el valor de json['title'] a String.
  // Lo mismo para las demás propiedades.
  factory Media.fromJson(Map<String, dynamic> json) {
    // Aquí tenemos algo particular ya que la propiedad `director` es una
    // propiedad de `Movie` y no de `Serie`.
    // Para saber si el JSON que recibimos es de una película o de una serie lo
    // que hacemos es verificar si el JSON contiene la propiedad `director`.
    if (json.containsKey('director')) {
      return Movie(
        title: json['title'] as String,
        year: json['year'] as int,
        genre: json['genre'] as String,
        director: json['director'] as String,
      );
    } else if (json.containsKey('directors')) {
      // Aquí tenemos algo particular ya que la propiedad `directors` es una
      // lista.
      // Para convertir la lista de `dynamic` a `String` utilizamos el método
      // `map` de la clase `List`. Este método recibe una función que recibe un tipo de dato y retorna un tipo de dato.
      // 1. Convertimos `json['directors']` en una lista de `dynamic` con el
      //    operador `as`.
      // 2. Luego utilizamos el método map para convertir cada elemento de la
      //    lista de `dynamic` a `String`.
      // 3. Finalmente convertimos todo a una lista de `String`
      final directors =
          (json['directors'] as List<dynamic>).map((e) => e as String).toList();
      return Serie(
        title: json['title'] as String,
        year: json['year'] as int,
        genre: json['genre'] as String,
        directors: directors,
      );
    } else {
      // Si el JSON no contiene la propiedad `director` ni la propiedad `directors` es porque el JSON no es válido.
      throw FormatException('Invalid JSON: $json');
    }
  }
}
```

De esta manera, lanzamos una `FormatException` si algo erróneo sucede en el proceso y utilizamos el _factory constructor_ de `Media` para crear una o la otra clase según lo que estemos recibiendo. 💀 Nos faltaría agregarles a las subclases los `fromJson` correspondientes! Qué esperan?

```dart
class Movie extends Media {
  final String director;

  Movie({
    required String title,
    required int year,
    required String genre,
    required this.director,
  }) : super(
          title: title,
          year: year,
          genre: genre,
        );

  factory Movie.fromJson(Map<String, Object?> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'] as int,
      genre: json['genre'] as String,
      director: json['director'] as String,
    );
  }
}

class Serie extends Media {
  final List<String> directors;

  Serie({
    required String title,
    required int year,
    required String genre,
    required this.directors,
  }) : super(
          title: title,
          year: year,
          genre: genre,
        );

  factory Serie.fromJson(Map<String, Object?> json) {
    final directors =
        (json['directors'] as List<String?>).map((e) => e as String).toList();
    return Serie(
      title: json['title'] as String,
      year: json['year'] as int,
      genre: json['genre'] as String,
      directors: directors,
    );
  }
}
```

Y esto no estaría completo sin tests! 💀 A ver cómo testean estas clases?

```dart
void main() {
  group('Given a Media', () {
    test('When fromJson() is called with a Movie, Then returns a Movie', () {
      final json = {
        'title': 'The Godfather',
        'year': 1972,
        'genre': 'Drama',
        'director': 'Francis Ford Coppola',
      };

      final media = Media.fromJson(json);

      expect(media, isA<Movie>());
    });

    test('When fromJson() is called with a Serie, returns a Serie', () {
      final json = {
        'title': 'Breaking Bad',
        'year': 2008,
        'genre': 'Drama',
        'directors': ['Vince Gilligan'],
      };

      final media = Media.fromJson(json);

      expect(media, isA<Serie>());
    });

    test(
        'When fromJson() is called with a wrong Json, throws a FormatException',
        () {
      final json = {
        'title': 'The Godfather',
        'year': 1972,
        'genre': 'Drama',
        'test': 'test',
      };

      expect(() => Media.fromJson(json), throwsFormatException);
    });
  });

  group('Given a Movie', () {
    test('When fromJson() is called, Then returns a Movie', () {
      final json = {
        'title': 'The Godfather',
        'year': 1972,
        'genre': 'Drama',
        'director': 'Francis Ford Coppola',
      };

      final movie = Movie.fromJson(json);

      expect(movie.title, 'The Godfather');
      expect(movie.year, 1972);
      expect(movie.genre, 'Drama');
      expect(movie.director, 'Francis Ford Coppola');
    });
  });

  group('Given a Serie', () {
    test('When fromJson() is called, Then returns a Serie', () {
      final json = {
        'title': 'Breaking Bad',
        'year': 2008,
        'genre': 'Drama',
        'directors': ['Vince Gilligan'],
      };

      final serie = Serie.fromJson(json);

      expect(serie.title, 'Breaking Bad');
      expect(serie.year, 2008);
      expect(serie.genre, 'Drama');
      expect(serie.directors, ['Vince Gilligan']);
    });
  });
}
```

### `expect(() => Media.fromJson(json), throwsFormatException)`

En este caso, se utiliza una función anónima en el argumento del método `expect` porque la función `Media.fromJson(json)` debe ser evaluada dentro del método `expect` para que se pueda verificar si lanza una excepción `FormatException`.

La sintaxis `() => Media.fromJson(json)` crea una función anónima sin argumentos que invoca el método `Media.fromJson(json)` al ser llamada. En este caso, se utiliza para encapsular la llamada a `Media.fromJson(json)`.

La razón por la que se utiliza una función anónima en lugar de llamar directamente a `Media.fromJson(json)` es porque `expect` espera que se le pase una función que pueda ser ejecutada para verificar si se produce una excepción. Si llamamos a `Media.fromJson(json)` directamente en el argumento, se producirá una excepción de inmediato y `expect` no podrá verificarla.

Al envolver la llamada a `Media.fromJson(json)` en una función anónima, podemos pasar la función en sí misma como argumento a `expect`, y `expect` se encargará de ejecutarla y verificar si lanza la excepción FormatException que esperamos.
