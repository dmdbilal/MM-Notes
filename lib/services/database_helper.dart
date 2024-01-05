import 'package:mm_notes/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Notes.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE Note(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, timestamp TEXT NOT NULL, hidden INTEGER)"
        );
      }, 
      // Whenever we're changing the database we can update it's version here.
      version: _version
    );
  }

  static Future<int> addNote(Note note) async {
    final db = await _getDB();

    return await db.insert("Note", note.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    
    return await db.update("Note", note.toJson(), where: 'id = ?', whereArgs: [note.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();

    return await db.delete("Note", where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<Note?> getNote(int? id) async {
    final db = await _getDB();
    
    List<Map<String, dynamic>> note = await db.query("SELECT title, description, timestamp, hidden FROM Note WHERE `id`=`$id`");

    if (note.isEmpty) {
      return null;
    }

    return Note.fromJson(note[0]);
  }

  static Future<List<Note>?> getAllNotes(bool showHidden) async {
    final db = await _getDB();

    List<Map<String, dynamic>> maps = await db.query("Note");
    
    if (maps.isEmpty) {
      return null;
    }

    List<Note> notes = [];
    for (Map<String, dynamic> item in maps) {
      Note note = Note.fromJson(item);

      if (showHidden) {
        notes.add(note);
      } else if (note.hidden == 0){ // Note is not hidden.
        notes.add(note);
      }
    }
    
    // return List.generate(
    //   maps.length, 
    //   (index) => Note.fromJson(maps[index]) // Converting each Map object to Note and collecting it in the list.
    // );

    return notes;
  }
}