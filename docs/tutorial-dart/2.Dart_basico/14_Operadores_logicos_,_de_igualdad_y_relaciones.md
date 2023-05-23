---
sidebar_position: 14
---

# Operadores lógicos, de igualdad y relacionales

Los _equality and relational operators_ u operadores de igualdad y relacionales nos permiten comparar expresiones. Todos tienen en común que el resultado será un `bool`:

Igual: __`==`__ `print(5==2)`
No igual: __`!=`__ `print(5!=2)`
Mayor que: __`>`__ `print(5>2)`
Menor que: __`<`__ `print(5<2)`
Mayor o igual: __`>=`__ `print(5>=2)`
Menor o igual: __`<=`__ `print(5<=2)`

En este caso, utilizamos utilizamos `int` _literals_ pero tengan en cuenta que podemos utilizar las expresiones que queramos y mezclar literales con variables, siempre que sean _compatibles_. 🤨 Fíjense qué pasa si tratan de comparar `print(5 < 2.5);`. Llegaron a alguna conclusión?

Cómo harían sin embargo, si quisieran comparar múltiples expresiones?

## Logical operators

Los operadores lógicos pueden ser utilizados invertir o combinar _boolean expressions_ (expresiones booleanas: dan como resultado `true` o `false`):

- __`!expr`__ llamado en lógica __negación__ o _not_ invierte el valor de la expresión (`expr` es una expresión. Puede ser una comparación entre dos números, un bool, etc.): `print(!false)`
- __`||`__ llamado __disyunción__ u _or_ retorna `true` si un lado o el otro son `true`. Al encontrar `true` retorna `true`, y ya no evalúa las siguientes. Sólo retorna `false` si ambas expresiones son falsas: `print(false||true)`
- __`&&`__ llamado __conjunción__ o _and_ retorna: `true` si ambos lados retornan `true` y si encuentra algún `false` deja de evaluar y devuelve `false`:  `print(true&&false)`

Tienen que tener en cuenta que los operadores relacionales tienen precedencia sobre los lógicos, por lo que estos últimos se evalúan al final y ustedes pueden hacer algo como lo siguiente sin la necesidad de usar paréntesis:

```dart
void main() {
    print(5 > 2 || 5 > 7); // true - observen que no evalúa
                           // la segunda expresión ya que la
                           // primera resulta en true
    print(5 < 2 && 5 > 7); // false
}
```

Si tienen operaciones más complejas, pueden utilizar los `()` para ejecutar lo que se encuentra dentro del paréntesis primero:

```dart
void main() {
    print((5 > 2 || 5 > 7) && 5 == 6); // false
}
```

Y si queremos cambiar su valor final, podemos utilizar el _NOT operator_ `!expr`, que luego de que la expresión ha sido evaluada, invierte su valor:

```dart
void main() {
    print(!((5 > 2 || 5 > 7) && 5 == 6)); // true
}
```

## 💪 Validación básica de email

__Requirement__: utilizar lo aprendido para hacer una validación de correo electrónico chequeando que:

1. El correo provisto no esté vacío.
2. El correo provisto contenga '@'.

__Extra__: los `String` tienen un método llamado 'isNotEmpty' que arroja `true` si dicho `String` no se encuentra vacío ya que podríamos declarar un `String` vacío (sin caracteres dentro aunque no nulo), de la siguiente manera: `String myEmptyString = '';`.

__💀 Solución__:

```dart
void main() {
  String email = 'test@example.com';
  print(
      'Is email \'$email\' valid?: ${email.isNotEmpty && email.contains('@')}'); //
}
```
