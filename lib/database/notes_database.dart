import 'package:notes_flutter/database/notes.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static Database? _database;
  var notesTable = "notes";

  NotesDatabase() {
    createDatabase();
  }

  Future<void> createDatabase() async {
    try {
      _database = await openDatabase('notes.db', onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE IF NOT EXISTS $notesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT, createdAT TIMESTAMP)");
      }, version: 1);
    } catch (exception) {
      print("exception $exception");
    }
  }

  Future<List<Notes>> getNotes() async {
    print("getNotes");
    final maps = await _database?.query(notesTable);
    List<Notes> objectList =
        List<Notes>.from(maps!.map((x) => Notes.fromMap(x)));
    print("objectList ${objectList.length}");
    return objectList;
  }

  Future<int> insertNotes(Notes notes) async {
    return _database?.insert(notesTable, notes.toJson(),
            conflictAlgorithm: ConflictAlgorithm.abort) ??
        Future.value(-1);
  }

  Future<int> updateNotes(Notes notes) async {
    return _database?.update(notesTable, notes.toJson(),
            conflictAlgorithm: ConflictAlgorithm.abort) ??
        Future.value(-1);
  }
}
