---
sidebar_position: 3
---

# Inferencia de tipo

Como Dart es un lenguaje de tipado estático (_statically typed language_), puede inferir las variables que declaramos. Para ello, en lugar de declarar de qué tipo es esa variable (si es una `String` o un `int` por ejemplo), utilizamos el término `var` que refiere a _variable_ y dejamos que Dart se encargue de eso:

```dart
void main() {
    var myName = 'Mau';
    var myAge = 38;
    var myHeight = 1.65;
}
```

Ahora... cómo podría demostrarles esto? Cómo podemos chequear si un tipo es exactamente del tipo que pensamos que es? 🤔

## Type test operators u Operadores de testeo de tipo

Nos permiten chequear en _runtime_ o tiempo de ejecución si __un tipo es ese que esperamos__:

- _variable_ __`is`__ _type_: devolverá `true` si la variable __es__ de ese tipo.
- _variable_ __`is!`__ _type_: devolverá `true` si la variable __no es__ de ese tipo.

Luego veremos esto más claramente cuando aprendamos sobre `Objects` y `Classes` pero por el momento, ya __tenemos todo para testear si nuestras variables fueron correctamente inferidas.__

## Combinando asserts y type test operators

Una vez que la variable fue inferida podemos con un `assert`, chequear si dicha variable fue tipada correctamente:

```dart
void main() {
    var myName = 'Mau';
    var myAge = 38;
    var myHeight = 1.65;
    assert(myName is String);
    assert(myAge is int);
    assert(myHeight is double);
}
```

💀 Pueden probar cambiando los tipos o las variables y viendo como el programa lanza (_throw_) una excepción cada vez. También probar qué sucede si intentan asignarle un valor nuevo que sea de un tipo distinto!
