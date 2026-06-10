import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mindtrack.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // 🛠️ Subimos la versión a 2 para forzar a la app a actualizar las tablas viejas
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Creación inicial de las tablas de la App
  Future _createDB(Database db, int version) async {
    // 1. TABLA USUARIOS
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL UNIQUE,
        contrasena TEXT NOT NULL
      )
    ''');

    // 2. TABLA RUTINAS (Maneja compatibilidad de columnas en minúscula y camelCase)
    await db.execute('''
      CREATE TABLE rutinas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        usuario_id INTEGER, 
        titulo TEXT NOT NULL,
        fecha TEXT NOT NULL,
        completado INTEGER NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    // 3. TABLA TRATAMIENTOS
    await db.execute('''
      CREATE TABLE tratamientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        usuario_id INTEGER,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        completado INTEGER NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');
  }

  // 🛠️ MÉTODOS AUXILIARES DE INSERCIÓN GENERAL PARA EL CONTROL DE LOGS
  Future<int> insertarUsuario(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('usuarios', row);
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo) async {
    final db = await instance.database;
    final res = await db.query('usuarios', where: 'correo = ?', whereArgs: [correo]);
    return res.isNotEmpty ? res.first : null;
  }

  // Si incrementas la versión del archivo, esto limpia los esquemas rotos sin necesidad de desinstalar manualmente
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("DROP TABLE IF EXISTS rutinas");
      await db.execute("DROP TABLE IF EXISTS tratamientos");
      await _createDB(db, newVersion);
    }
  }
}
