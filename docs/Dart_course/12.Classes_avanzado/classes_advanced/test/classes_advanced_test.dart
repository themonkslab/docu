import 'package:classes_advanced/src/classes_advanced_base.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Animal class,', () {
    //Given
    late Animal animal;
    setUp(() {
      animal = Animal(scientificName: 'Animalus');
    });

    test('when "scientificName" is called, then it should return a String', () {
      // When
      final result = animal.scientificName;

      // Then
      expect(result, isA<String>());
    });
    // we avoid printing for now
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = animal.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = animal.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = animal.breath();

      // Then
      expect(result, '💨 breathing');
    });
  });

  group('Given a Dog class', () {
    //Given
    late Dog dog;
    setUp(() {
      dog = Dog(scientificName: 'Perrus');
    });
    test(
        'when sleep is called, then it should return & (print) "I\'m a dog and I ❤️ to sleep!, after calling super.sleep that has secrets!"',
        () {
      // When
      final result = dog.sleep();

      // Then
      expect(result, 'I\'m a dog and I ❤️ to sleep!');
    });

    // we avoid printing for now
    test(
        'when eat is called, then it should return & (print) "I am a Dog! I am 🥩 eating"',
        () {
      // When
      final result = dog.eat();

      // Then
      expect(result, 'I am a Dog! I am 🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = dog.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when bark is called, then it should return & (print) "🐶 barking"',
        () {
      // When
      final result = dog.bark();

      // Then
      expect(result, '🐶 barking');
    });
  });

  group('Given a Cat class', () {
    //Given
    late Cat cat;
    setUp(() {
      cat = Cat(scientificName: 'Gatitus');
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = cat.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = cat.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = cat.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when meow is called, then it should return & (print) "🐱 meowing"',
        () {
      // When
      final result = cat.meow();

      // Then
      expect(result, '🐱 meowing');
    });
  });

  group('Given a SuperDog class', () {
    //Given
    late SuperDog superDog;
    setUp(() {
      superDog = SuperDog(scientificName: 'SuperPerrus');
    });
    test('when sleep is called, then it should return & (print) "💤 sleeping"',
        () {
      // When
      final result = superDog.sleep();

      // Then
      expect(result, '💤 sleeping');
    });

    // we avoid printing for now
    test('when eat is called, then it should return & (print) "🥩 eating"', () {
      // When
      final result = superDog.eat();

      // Then
      expect(result, '🥩 eating');
    });

    // we avoid printing for now
    test(
        'when breathe is called, then it should return & (print) "💨 breathing"',
        () {
      // When
      final result = superDog.breath();

      // Then
      expect(result, '💨 breathing');
    });
    // we avoid printing for now
    test('when bark is called, then it should return & (print) "🐶 barking"',
        () {
      // When
      final result = superDog.bark();

      // Then
      expect(result, '🐶 barking');
    });

    test(
        'when throwXRay is called, then it should return & (print) "🥽 throwing X-Ray - Cyclops is my little brother! 🤣"',
        () {
      // When
      final result = superDog.throwXRay();

      // Then
      expect(result, '🥽 throwing X-Ray - Cyclops is my little brother! 🤣');
    });
  });
}
