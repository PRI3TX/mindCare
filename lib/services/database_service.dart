import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';
import '../models/rutina.dart';

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
      version: 2, // 👈 CAMBIADO A VERSIÓN 2: Forzamos la actualización de la estructura
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB, // 👈 NUEVO: Maneja la migración si la app ya estaba instalada
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabla de Usuarios
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL UNIQUE,
        contrasena TEXT NOT NULL
      )
    ''');

    // Tabla de Rutinas
    await db.execute('''
      CREATE TABLE rutinas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        fecha TEXT NOT NULL,
        completado INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de Tratamientos 
    // 👈 CORREGIDO: Se cambiaron las columnas para coincidir con tu modelo 'Tratamiento' (nombre, descripcion, fecha)
    await db.execute('''
      CREATE TABLE tratamientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        completado INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');
  }

  // 🔄 MIGRACIÓN: Si el usuario ya tenía la versión 1, este método le creará la tabla tratamientos sin borrar sus datos
  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS tratamientos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario_id INTEGER NOT NULL,
          nombre TEXT NOT NULL,
          descripcion TEXT NOT NULL,
          fecha TEXT NOT NULL,
          completado INTEGER NOT NULL,
          FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // --- OPERACIONES DE USUARIO ---
  Future<int> registrarUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo) async {
    final db = await instance.database;
    final maps = await db.query(
      'usuarios',
      where: 'correo = ?',
      whereArgs: [correo],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  // --- OPERACIONES DE RUTINAS (FILTRADAS) ---
  Future<int> insertarRutina(Rutina rutina) async {
    final db = await instance.database;
    return await db.insert('rutinas', rutina.toMap());
  }

  Future<List<Map<String, dynamic>>> obtenerRutinasPorUsuario(int usuarioId) async {
    final db = await instance.database;
    return await db.query(
      'rutinas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
  }

  Future<int> actualizarRutina(Rutina rutina) async {
    final db = await instance.database;
    return await db.update(
      'rutinas',
      rutina.toMap(),
      where: 'id = ?',
      whereArgs: [rutina.id],
    );
  }

  Future<int> eliminarRutina(int id) async {
    final db = await instance.database;
    return await db.delete(
      'rutinas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> cerrar() async {
    final db = await instance.database;
    db.close();
  }
}