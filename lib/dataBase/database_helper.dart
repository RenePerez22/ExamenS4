import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<int> insertarEstudiante(Map<String, dynamic> estudiante) async {
    final db = await database;
    return await db.insert('estudiantes', estudiante);
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'cursos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE estudiantes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            edad INTEGER,
            fecha TEXT,
            pais TEXT,
            ciudad TEXT,
            cuota_inicial REAL,
            cuota_mensual REAL,
            valor_final REAL
          )
        ''');
      },
    );
  }
}
