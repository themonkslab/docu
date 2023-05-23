import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal();
    });
    // we avoid printing for now
    test('when sleep is called, then it should return & (print) "sleeping"',
        () {
      // When
      final result = animal.sleep();

      // Then
      expect(result, 'sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "eating"', () {
      // When
      final result = animal.eat();

      // Then
      expect(result, 'eating');
    });

    // we avoid printing for now
    test('when breathe is called, then it should return & (print) "breathing"',
        () {
      // When
      final result = animal.breath();

      // Then
      expect(result, 'breathing');
    });
  });
}
