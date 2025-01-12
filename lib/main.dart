import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:noteapp/student.dart';
import 'package:noteapp/studentinfo.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>('students');
  runApp(const MyNoteApp());
}

class MyNoteApp extends StatelessWidget {
  const MyNoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Box<Student> studentBox;

  @override
  void initState() {
    super.initState();
    studentBox = Hive.box<Student>('students');

    if (studentBox.isEmpty) {
      studentBox.addAll([
        Student("Saron", "Get married.", "pic1.jpg"),
        Student("Samuel", "Own a car.", "pic2.jpg"),
        Student("Caleb", "Move to London.", "pic2.jpg"),
        Student("Rodas", "Own a house.", "pic1.jpg"),
        Student("Rediet", "Own a business.", "pic1.jpg"),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Student List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/bdu.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Text(
                    "bdu@edu.et",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text("Home", style: TextStyle(color: Colors.black)),
              trailing: const Icon(Icons.mobile_friendly),
              onTap: () => print('Home clicked'),
            ),
            const ListTile(
              title: Text("About", style: TextStyle(color: Colors.black)),
            ),
            const ListTile(
              title: Text("Settings", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: studentBox.listenable(),
        builder: (context, Box<Student> box, _) {
          final students = box.values.toList();
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 4.0,
                child: ListTile(
                  leading: student.pic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            "assets/${student.pic}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          child: Text(
                            student.studentname[0],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                  title: Text(
                    student.studentname,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(student.plan),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewUserInfo(
                            student: student,
                            index: index,
                          ),
                        ),
                      );

                      if (result != null) {
                        studentBox.putAt(
                          index,
                          Student(
                            result['name'],
                            result['note'],
                            student.pic, 
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewUserInfo()),
          );

          if (result != null) {
            final newStudent = Student(result['name'], result['note']);
            await studentBox.add(newStudent);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}