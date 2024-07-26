
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatos {
  static Database? _database; 
  static const int versionBD = 1; 
  static const String nombreBD = "InterapasGenApp_v0.$versionBD.db";


  static final BaseDatos bd = BaseDatos._init();

    
  BaseDatos._init();

  Future<Database> get database async {   //Para acceder a la instancia de la base de datos.
    if (_database != null) return _database!;

    return _database = await _initDB(nombreBD);
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: versionBD, onCreate: _createDB, onUpgrade: _upgradeDB, onDowngrade: _downgradeDB);
  }
  
  Future _createDB(Database db, int version) async {    //Función que se ejecuta cuando no existía la base de datos, y se crea.
    await db.execute('''
      CREATE TABLE S_CONEXION(
        CL_API TEXT NOT NULL
        , API_PRIMARIA TEXT NOT NULL
        , DIR_PRIMARIA TEXT NOT NULL
        , API_SECUNDARIA TEXT
        , DIR_SECUNDARIA TEXT
        , FG_ACTIVA BOOLEAN DEFAULT 0 NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE S_SESION_USUARIO(
        ID_USUARIO INTEGER PRIMARY KEY
        , ID_EMPLEADO INTEGER NOT NULL
        , CL_USUARIO TEXT NOT NULL
        , CL_CONEXION TEXT NOT NULL
        , FG_ACTIVO BOOLEAN DEFAULT 0 NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE K_CORTE(
        ID_CORTE INTEGER PRIMARY KEY
        , ID_USUARIO INTEGER NOT NULL
        , ID_CORTE_APP INTEGER NOT NULL
        , ID_CONTRATO INTEGER NOT NULL
        , CL_RUTA TEXT
        , CL_INTERNET TEXT NOT NULL
        , NB_MUNICIPIO TEXT
        , NB_COLONIA TEXT NOT NULL
        , NB_CALLE TEXT NOT NULL
        , NO_EXTERIOR TEXT NOT NULL
        , NO_INTERIOR TEXT
        , CL_CODIGO_POSTAL TEXT
        , MN_ADEUDO REAL DEFAULT 0.0 NOT NULL
        , NO_MESES_ADEUDO INTEGER DEFAULT 0
        , DS_FOTOS TEXT
        , DS_OBSERVACIONES TEXT
        , FG_ESTADO INTEGER DEFAULT 0 NOT NULL
        , FE_CAPTURA TEXT
      );
    ''');
  }
  
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {    //Función que se ejecuta cuando el número de versión es mayor al instalado.
  }

  Future _downgradeDB(Database db, int oldVersion, int newVersion) async {    //Función que se ejecuta cuando el número de versión es menor al instalado.
  }

  Future close() async {
    final db = await bd.database;
    db.close();
  }

}