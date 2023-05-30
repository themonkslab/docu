import 'package:company_example/company_example.dart';

void main() {
  final owner = Owner(
    fullName: 'Sarah Smith',
    measureProductivity: (Employee employee) {
      final productivity = employee.reportToOwner() / 10;
      print('📇 The productivity of ${employee.fullName} is $productivity');
      return 'The productivity of ${employee.fullName} is $productivity';
    },
  );

  final manager = Manager(
    fullName: 'John McEnroe',
    id: 1,
    salary: 1000,
    projectsManaged: 14,
  );

  final engineer = Engineer(
    fullName: 'Stuart Little',
    id: 1,
    salary: 1000,
    bugsFixed: 147,
  );

  owner.measureProductivity(manager);
  owner.measureProductivity(engineer);
}
