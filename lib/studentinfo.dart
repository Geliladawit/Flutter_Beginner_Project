import 'package:flutter/material.dart';
import 'package:noteapp/student.dart';

class NewUserInfo extends StatefulWidget {
  final Student? student;
  final int? index;

  const NewUserInfo({Key? key, this.student, this.index}) : super(key: key);

  @override
  State<NewUserInfo> createState() => _NewUserInfoState();
}

class _NewUserInfoState extends State<NewUserInfo> {
  late TextEditingController _nameController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.student?.studentname ?? '',
    );
    _noteController = TextEditingController(
      text: widget.student?.plan ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Enter Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back without saving
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String note = _noteController.text.trim();

                    if (name.isNotEmpty && note.isNotEmpty) {
                      Navigator.of(context).pop({
                        'name': name,
                        'note': note,
                      });
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}