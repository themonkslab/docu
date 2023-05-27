import 'package:generic_classes/generic_classes.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Result class', () {
    late Result result;
    test(
        'When created with a success use case, Then Result.value should not be an AppException',
        () {
      result = Result(value: 'Success');
      expect(result.value, isNot(isA<AppException>()));
    });

    test(
        'When created with a success use case of value type int, Then Result.value should be an int',
        () {
      result = Result<int, AppException>(value: 1);
      expect(result.value, isA<int>());
    });

    test(
        'When created with a success use case  of value type String, Then Result.value should be a String',
        () {
      result = Result<String, AppException>(value: 'Success');
      expect(result.value, isA<String>());
    });
    test(
        'When created with a success use case  of value type bool, Then Result.value should be a bool',
        () {
      result = Result<bool, AppException>(value: false);
      expect(result.value, isA<bool>());
    });

    test(
        'When created with an error use case, Then Result.error should be an AppException',
        () {
      result = Result<int, AppException>(error: AppException('Error'));
      expect(result.error, isA<AppException>());
      expect(() => throw (result.error!), throwsException);
    });
  });

  group(
    'Given a call to processRequest',
    () {
      test(
          'When I call it with returnError = true, Then the result should be a Result with value of AppException and message This is an error',
          () {
        final result = processRequest(returnError: true);
        expect(result.error, isA<AppException>());
        expect(result.error?.message, 'This is an error');
      });

      test(
          'When I call it with returnError = false, Then the result should be a Result with value of type int',
          () {
        final result = processRequest(returnError: false);
        expect(result.value, isA<int>());
      });
    },
  );
}
