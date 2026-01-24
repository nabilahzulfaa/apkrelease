import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDb {
  NoteDb._init();

  static final NoteDb instance = NoteDb._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        deadline INTEGER
      )
    ''');
  }

  Future<int> insert(Map<String, Object?> row) async {
    final db = await instance.database;
    return await db.insert('notes', row);
  }

  Future<List<Map<String, Object?>>> queryAll() async {
    final db = await instance.database;
    return await db.query('notes', orderBy: 'deadline ASC, createdAt DESC');
  }

  Future<int> update(int id, Map<String, Object?> row) async {
    final db = await instance.database;
    return await db.update('notes', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
