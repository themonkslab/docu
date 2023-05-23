---
sidebar_position: 2
---

# Parseando argumentos desde la línea de comandos

Creo que ya dijimos que parsear significa analizar y convertir un valor en otro, típicamente de formato interno, un valor que podamos utilizar para nuestros fines específicos.

Bien, aquí lo que vamos a crear es un programa que nos permita leer un archivo `.csv`, parsearlo para convertirlo a valores que podamos utilizar, hacer algo útil con ellos y finalmente mostrarnos el resultado esperado!

Empecemos recordando cómo crear un proyecto en Dart y nuestro primer archivo:

1. Vayan a su línea de comandos o terminal.
2. Creen un directorio para este proyecto: `mkdir data_processing`.
3. Entren a dicho directorio: `cd data_processing` (recuerden que pueden utilizar la tecla `tab` para autocompletar).
4. Abran una nueva instancia de VSCode dentro: `code .`.
5. Creen un nuevo archivo llamado `data_processing.dart`.

Una vez allí, lo que queremos hacer ahora, es crear un programa para línea de comandos que reciba un argumento que represente el lugar o _path_ en donde se encuentra nuestro archivo a procesar para luego poder hacer algo con el.

Ya sabemos cómo empezar un programa de Dart, cómo establecer su punto de entrada pero cómo hacemos que reciba argumentos? Todavía no vimos lo que son las funciones pero `void main() {}` es una función y dentro de los paréntesis, ella puede recibir argumentos del tipo que nosotros establezcamos. Fíjense qué sucede si hacemos lo siguiente:

```dart
void main(List<String> arguments) {
    print(arguments);
}
```

Estamos creando un programa que recibe una lista de argumentos del tipo `String` para luego imprimirlos. 💀 Vayan a guardar ya mismo ese programa y córranlo así: `dart data_processing.dart Mis argumentos!`. Qué creen que sucederá?

![Imprimiendo arguments](2.2_imprimiendo_argumentos.png)

Interesante no? Bien! Ahora, como vamos a necesitar de forma obligatoria un archivo para luego procesar, este programa no puede ejecutarse sin introducir el _path_ de ese archivo como argumento. Qué les parece si prevenimos al usuario de ello?

```dart
void main(List<String> arguments) {
  ---
sidebar_position: 1
---if (arguments.isEmpty) {
    print('Usage: dart data_processing.dart <inputFile.csv>');
  } else {
    print(arguments); //no debería imprimir nada ya que aun no tenemos argumentos
  }
  print('Esto no debería imprimirse'); 
}
```

Sin embargo el programa debiera terminar automáticamente cuando lo corremos sin argumentos. Para ello vamos a hacer uso de la librería `dart:io` y su función `exit`: esta nos permite terminar el programa pidiéndonos un argumento: `0` si no tiene errores y `1` si tiene algún error. De esta forma, evitamos la utilización del `else` y podemos ver en nuestra terminal que se ejecuta pero no imprime las ultimas dos lineas gracias a la función `exit`:

```dart
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart data_processing.dart <inputFile.csv>');
    exit(1);
  }
  print(arguments);
  print('Esto no debería imprimirse');
}
```

Finalmente podríamos correr nuestro programa agregando el _path_ del archivo o _input file_ y que eso sea lo que imprimamos:

```dart
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart data_processing.dart <inputFile.csv>');
    exit(1);
  }
  final inputFile = arguments.first; //si el programa recibiera dos archivos como argumento desde la línea de comando esta variable tomaría el valor del path del primero de ellos
  print(inputFile);
}
```
