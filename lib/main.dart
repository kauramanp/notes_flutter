import 'package:flutter/material.dart';

import 'database/notes.dart';
import 'database/notes_database.dart';

void main() {
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
  void initState() {
    super.initState();
    print("in init state");
    getNotes();
  }

  Future<List<Notes>> getNotes() {
    return _notesDatabase.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getNotes(),
          builder: ((context, AsyncSnapshot<List<Notes>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: _showDialog(position: index),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(snapshot.data?[index].title ?? ""),
                          Text(snapshot.data?[index].description ?? "")
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data?.length,
                shrinkWrap: true,
              );
            } else {
              return Container();
            }
          })),
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
                            _notesDatabase.updateNotes(notes).then((value) =>
                                {getNotes(), Navigator.of(context).pop()})
                          }
                        : _notesDatabase.insertNotes(notes).then((value) =>
                            {getNotes(), Navigator.of(context).pop()});
                  },
                  child: Text(position > -1 ? "Update" : "Add"))
            ],
          );
        }));
  }
}
