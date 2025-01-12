import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 1)
class Student {
  @HiveField(0)
  String studentname;

  @HiveField(1)
  String plan;

  @HiveField(2)
  String? pic;

  Student(this.studentname, this.plan,[ this.pic]);
}
