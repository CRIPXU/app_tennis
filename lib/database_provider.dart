import 'package:cancha_tennis/model_agendamiento.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._();
  static Database? _database;


  DatabaseProvider._();

  Future<void> initializeDatabaseProvider() async {
    _database = await _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'agendamientos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE agendamientos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cancha TEXT,
            fecha TEXT,
            usuario TEXT
          )
        ''');
      },
    );
  }
  //insertar
  Future<void> insertAgendamiento(Agendamiento agendamiento) async {
    final db = await database;
    await db.insert('agendamientos', agendamiento.toMap());
  }
  //obtener
  Future<List<Agendamiento>> getAgendamientos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agendamientos');
    return maps.map((map) => Agendamiento.fromMap(map)).toList();
  }
  //Eliminar
  Future<void> deleteAgendamiento(int id) async {
    final db = await database;
    await db.delete(
      'agendamientos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
