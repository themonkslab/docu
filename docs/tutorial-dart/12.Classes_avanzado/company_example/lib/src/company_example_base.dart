class Owner {
  Owner({
    required this.fullName,
    required this.measureProductivity,
  });

  String fullName;
  String Function(Employee employee) measureProductivity;
}

abstract class Employee {
  Employee({
    required this.fullName,
    required this.id,
    required this.salary,
  });

  final String fullName;
  final int id;
  final double salary;

  int reportToOwner();
  String askForRaise();
}

class Manager extends Employee {
  Manager({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.projectsManaged,
  });

  final int projectsManaged;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  int reportToOwner() => projectsManaged * 7;
}

class Engineer extends Employee {
  Engineer({
    required super.fullName,
    required super.id,
    required super.salary,
    required this.bugsFixed,
  });

  final int bugsFixed;

  @override
  String askForRaise() => 'I am asking for a raise';

  @override
  int reportToOwner() => bugsFixed * 2;
}
