import 'package:notes_flutter/database/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class NotesDatabase {
  static Database? _database;
  var notesTable = "notes";

  NotesDatabase() {
    createDatabase();
  }

  Future<void> createDatabase() async {s
    // var databaseFactory = databaseFactoryFfi;
    //var factory = databaseFactoryWebLocal;

    _database = await openDatabase(getDatabasesPath().s'notes.db'),
, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLED  $notesTable(id INTEGER PRIMARY KEY AUTO INCREMENT, title TEXT, description TEXT, createdAT TIMESTAMP)");
    }, version: 1);
  }

  insertNotes(Notes notes) async {
    await _database?.insert(notesTable, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  updateNotes(Notes notes) async {
    await _database?.update(notesTable, notes.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }
}
