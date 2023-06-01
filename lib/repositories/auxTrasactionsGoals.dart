import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String metasTABLE = "metasTable";
final String idColumn = "idColumn";
final String valorColumn = "valorColumn";
final String dataColumn = "dataColumn";
final String descricaoColumn = "descricaoColumn";

class auxMetas {
  int idM = 0;
  double valorM = 0.0;
  String dataM = " ";
  String descricaoM = " ";

  auxMetas();

  auxMetas.fromMap(Map map) {
    idM = map[idColumn];
    dataM = map[dataColumn];
    valorM = map[valorColumn];
    descricaoM = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, Object?> map = {
      valorColumn: valorM,
      dataColumn: dataM,
      descricaoColumn: descricaoM,
    };
    if (idM != null) {
      map[idColumn] = idM;
    }
    return map;
  }

  String toString() {
    return "auxMetas(id: $idM, valor: $valorM, data: $dataM, desc: $descricaoM, )";
  }
}

class auxMetasHelper {
  static final auxMetasHelper _instance = auxMetasHelper.internal();

  factory auxMetasHelper() => _instance;

  auxMetasHelper.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  set db(Future<Database?> newDb) {
    _db = newDb as Database?;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "metas.db");
    print("create db");
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $metasTABLE(" +
          "$idColumn INTEGER PRIMARY KEY AUTOINCREMENT," +
          "$valorColumn FLOAT," +
          "$dataColumn TEXT," +
          "$descricaoColumn TEXT)");
    });
  }

  Future<auxMetas> saveMetas(auxMetas auxmetas) async {
    print("chamada save");
    Database? dbMetas = await db;
    if (dbMetas != null) {
      int lastId = Sqflite.firstIntValue(
              await dbMetas.rawQuery('SELECT MAX(idColumn) FROM metasTABLE')) ??
          0;
      auxmetas.idM = lastId + 1;
      auxmetas.idM = await dbMetas.insert(
        metasTABLE,
        auxmetas.toMap().cast<String, Object?>(),
      );
    } else {
      throw Exception("O banco de dados não está inicializado");
    }
    return auxmetas;
  }

  Future<auxMetas?> getMetas(int id) async {
    Database? dbMetas = await db;
    List<Map<String, Object?>>? maps = await dbMetas?.query(metasTABLE,
        columns: [idColumn, valorColumn, descricaoColumn],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps!.length > 0) {
      return auxMetas.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateMetas(auxMetas auxmetas) async {
    print("chamada update");
    print(auxmetas.toString());
    Database? dbMetas = await db;
    return await dbMetas!.update(
        metasTABLE, auxmetas.toMap().cast<String, Object?>(),
        where: "$idColumn =?", whereArgs: [auxmetas.idM]);
  }

  Future<List> getAllMetasMes(String data) async {
    Database? dbMetas = await db;
    List listMap = await dbMetas!
        .rawQuery("SELECT * FROM $metasTABLE WHERE $dataColumn LIKE '%$data%'");
    List<auxMetas> listMetas = [];

    for (Map m in listMap) {
      listMetas.add(auxMetas.fromMap(m));
    }
    return listMetas;
  }
}
