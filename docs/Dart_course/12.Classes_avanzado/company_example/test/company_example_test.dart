import 'package:company_example/company_example.dart';
import 'package:test/test.dart';

void main() {
  group('Given an Ownwer', () {
    late Owner owner;
    setUp(() {
      owner = Owner(
          fullName: 'John Doe', measureProductivity: (Employee employee) => '');
    });
    test('When I create an Owner, Then I get an Owner', () {
      expect(owner, isA<Owner>());
    });

    test(
        'When I create an Owner, Then I get an Owner with a fullName and a measureProductivity function',
        () {
      expect(owner.fullName, 'John Doe');
      expect(owner.measureProductivity, isA<Function>());
    });
  });

  group('Given a Manager', () {
    late Manager manager;
    setUp(() {
      manager = Manager(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        projectsManaged: 10,
      );
    });

    test(
        'When I create a Manager, Then I get a Manager with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(manager.fullName, 'John Doe');
      expect(manager.id, 1);
      expect(manager.salary, 1000);
      expect(manager.projectsManaged, 10);
      expect(manager.reportToOwner, isA<int Function()>()); // 👁️
      expect(manager.askForRaise, isA<Function>());
    });
  });

  group('Given an Engineer', () {
    late Engineer engineer;
    setUp(() {
      engineer = Engineer(
        fullName: 'John Doe',
        id: 1,
        salary: 1000,
        bugsFixed: 100,
      );
    });

    test(
        'When I create a Engineer, Then I get a Engineer with a fullName, an id, a salary, a getReport function and an askForRaise function',
        () {
      expect(engineer.fullName, 'John Doe');
      expect(engineer.id, 1);
      expect(engineer.salary, 1000);
      expect(engineer.bugsFixed, 100);
      expect(engineer.reportToOwner, isA<int Function()>()); // 👁️
      expect(engineer.askForRaise, isA<Function>());
    });
  });
}
