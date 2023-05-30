class Animal {
  const Animal({required this.scientificName});
  final String scientificName;

  final String _secretVariable = 'I am a secret!';
  String sleep() {
    final String sleepingString = '💤 sleeping. $_secretVariable';
    print(sleepingString);
    return sleepingString;
  }

  String eat() {
    const String eatingString = '🥩 eating';
    print(eatingString);
    return eatingString;
  }

  String breath() {
    const String breathingString = '💨 breathing';
    print(breathingString);
    return breathingString;
  }
}

class Dog extends Animal {
  Dog({required super.scientificName});

  @override
  String eat() {
    const String eatingString = 'I am a Dog! I am 🥩 eating';
    print(eatingString);
    return eatingString;
  }

  @override
  String sleep() {
    super.sleep();
    const String sleepingString = 'I\'m a dog and I ❤️ to sleep!';
    print(sleepingString);
    return sleepingString;
  }

  String bark() {
    const String barkingString = '🐶 barking';
    print(barkingString);
    return barkingString;
  }
}

class SuperDog extends Dog {
  SuperDog({required super.scientificName});

  String throwXRay() {
    const String throwingXRayString =
        '🥽 throwing X-Ray - Cyclops is my little brother! 🤣';
    print(throwingXRayString);
    return throwingXRayString;
  }
}

class Cat extends Animal {
  Cat({required super.scientificName});

  String meow() {
    const String meowingString = '🐱 meowing';
    print(meowingString);
    return meowingString;
  }
}
