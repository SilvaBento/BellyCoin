import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String movimentacaoTABLE = "movimentacaoTABLE";
final String idColumn = "idColumn";
final String dataColumn = "dataColumn";
final String valorColumn = "valorColumn";
final String tipoColumn = "tipoColumn";
final String descricaoColumn = "descricaoColumn";

class auxMovimentacoes {
  int ident = 0;
  String date = " ";
  double value = 0.0;
  String type = " ";
  String descr = " ";

  auxMovimentacoes();

  auxMovimentacoes.fromMap(Map map) {
    ident = map[idColumn];
    value = map[valorColumn];
    date = map[dataColumn];
    type = map[tipoColumn];
    descr = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, Object?> map = {
      valorColumn: value,
      dataColumn: date,
      tipoColumn: type,
      descricaoColumn: descr,
    };
    if (ident != null) {
      map[idColumn] = ident;
    }
    return map;
  }

  String toString() {
    return "auxMovimentacoes(id: $ident, valor: $value, data: $date, tipo: $type, desc: $descr, )";
  }
}

class auxMovimentacoesHelper {
  static final auxMovimentacoesHelper _instance =
      auxMovimentacoesHelper.internal();

  factory auxMovimentacoesHelper() => _instance;

  auxMovimentacoesHelper.internal();

  Database? _dbaux;

  Future<Database?> get dbaux async {
    if (_dbaux != null) {
      return _dbaux;
    } else {
      _dbaux = await initDb();
      return _dbaux;
    }
  }

  set db(Future<Database?> newDb) {
    _dbaux = newDb as Database?;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "auxmovimentacao.db");
    print("create db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $movimentacaoTABLE(" +
          "$idColumn INTEGER PRIMARY KEY AUTOINCREMENT," +
          "$valorColumn FLOAT," +
          "$dataColumn TEXT," +
          "$tipoColumn TEXT," +
          "$descricaoColumn TEXT)");
    });
  }

  Future<auxMovimentacoes> auxsaveMovimentacao(
      auxMovimentacoes auxmovimentacao) async {
    print("chamada save");
    Database? dbMovimentacoes = await dbaux;
    if (dbMovimentacoes != null) {
      int lastId = Sqflite.firstIntValue(await dbMovimentacoes
              .rawQuery('SELECT MAX(idColumn) FROM movimentacaoTABLE')) ??
          0;
      auxmovimentacao.ident = lastId + 1;
      auxmovimentacao.ident = await dbMovimentacoes.insert(
        movimentacaoTABLE,
        auxmovimentacao.toMap().cast<String, Object?>(),
      );
    } else {
      throw Exception("O banco de dados não está inicializado");
    }
    return auxmovimentacao;
  }

  Future<auxMovimentacoes?> getMovimentacoes(int id) async {
    Database? dbMovimentacoes = await dbaux;
    List<Map<String, Object?>>? maps = await dbMovimentacoes?.query(
        movimentacaoTABLE,
        columns: [
          idColumn,
          valorColumn,
          dataColumn,
          tipoColumn,
          descricaoColumn
        ],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps!.length > 0) {
      return auxMovimentacoes.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int?> deleteMovimentacao(auxMovimentacoes auxmovimentacao) async {
    Database? dbMovimentacoes = await dbaux;
    return await dbMovimentacoes?.delete(movimentacaoTABLE,
        where: "$idColumn =?", whereArgs: [auxmovimentacao.ident]);
  }

  Future<int> auxupdateMovimentacao(auxMovimentacoes auxmovimentacao) async {
    print("chamada update");
    print(auxmovimentacao.toString());
    Database? dbMovimentacoes = await dbaux;
    return await dbMovimentacoes!.update(
        movimentacaoTABLE, auxmovimentacao.toMap().cast<String, Object?>(),
        where: "$idColumn =?", whereArgs: [auxmovimentacao.ident]);
  }

  Future<List> getAllMovimentacoes() async {
    Database? dbMovimentacoes = await dbaux;
    List listMap =
        await dbMovimentacoes!.rawQuery("SELECT * FROM $movimentacaoTABLE");
    List<auxMovimentacoes> listMovimentacoesaux = [];

    for (Map m in listMap) {
      listMovimentacoesaux.add(auxMovimentacoes.fromMap(m));
    }
    return listMovimentacoesaux;
  }

  Future<List> getAllMovimentacoesPorMesSQL(String data) async {
    Database? dbMovimentacoes = await dbaux;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%'");
    List<auxMovimentacoes> listMovimentacoesaux = [];

    for (Map m in listMap) {
      listMovimentacoesaux.add(auxMovimentacoes.fromMap(m));
    }
    return listMovimentacoesaux;
  }

  Future<List> getAllMovimentacoesporDescricaoSQL(
      String data, String tipo) async {
    Database? dbMovimentacoes = await dbaux;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%' AND $tipoColumn LIKE '%$tipo%'");
    List<auxMovimentacoes> listMovimentacoesaux = [];

    for (Map m in listMap) {
      listMovimentacoesaux.add(auxMovimentacoes.fromMap(m));
    }
    return listMovimentacoesaux;
  }

  Future<List> getAllMovimentacoesPorTipoSQL(String tipo) async {
    Database? dbMovimentacoes = await dbaux;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $tipoColumn ='$tipo' ");
    List<auxMovimentacoes> listMovimentacoesaux = [];

    for (Map m in listMap) {
      listMovimentacoesaux.add(auxMovimentacoes.fromMap(m));
    }
    return listMovimentacoesaux;
  }

  Future<int?> getNumber() async {
    Database? dbMovimentacoes = await dbaux;
    return Sqflite.firstIntValue(await dbMovimentacoes!
        .rawQuery("SELECT COUNT(*) FROM $movimentacaoTABLE"));
  }

  Future close() async {
    Database? dbMovimentacoes = await dbaux;
    dbMovimentacoes!.close();
  }
}
