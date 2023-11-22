import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database/notes.dart';
import 'database/notes_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Notes> list = [];
  final NotesDatabase _notesDatabase = NotesDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(list[index].title), Text(list[index].description)],
          );
        },
        itemCount: list.length,
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialog({int position = -1}) {
    var titleController = TextEditingController();
    var descController = TextEditingController();
    if (position > -1) {
      titleController.text = list[position].title;
      descController.text = list[position].description;
    }
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: position > -1 ? const Text("Add") : const Text("Update"),
            content: Wrap(
              children: [
                TextField(
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Add Title",
                  ),
                ),
                TextField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Add Description",
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    var notes = Notes(
                        title: titleController.text,
                        description: descController.text,
                        createdAt:
                            DateTime.now().millisecondsSinceEpoch.toString());
                    position > -1
                        ? {
                            notes.createdAt = list[position].createdAt,
                            _notesDatabase.updateNotes(notes)
                          }
                        : _notesDatabase.insertNotes(notes);
                  },
                  child: Text(position > -1 ? "Update" : "Add"))
            ],
          );
        }));
  }
}
