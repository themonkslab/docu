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
