import 'package:generic_classes/src/generic_classes_base.dart';

void main() {
  final simulatedResult = processRequest(returnError: true);
  throw (simulatedResult.error!);
  // print(simulatedResult.value is String);
}
