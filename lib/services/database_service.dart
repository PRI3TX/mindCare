import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(
      await getDatabasesPath(),
      'mindtrack.db',
    );

    print("Base de datos: $path");

    return await openDatabase(
      path,
      version: 2,

      onCreate: (db, version) async {
        print("Creando tablas...");

        await db.execute('''
          CREATE TABLE rutinas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            completado INTEGER NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tratamientos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            completado INTEGER NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');

        print("Tablas creadas correctamente");
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        print("Actualizando BD: $oldVersion -> $newVersion");

        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE tratamientos(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              descripcion TEXT NOT NULL,
              completado INTEGER NOT NULL,
              fecha TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  static Future<void> borrarBD() async {
    final path = join(
      await getDatabasesPath(),
      'mindtrack.db',
    );

    await deleteDatabase(path);

    print("BASE DE DATOS ELIMINADA");
  }
}