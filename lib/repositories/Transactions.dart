import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

final String movimentacaoCollection = "movimentacaoCollection";
final String idField = "id";
final String dataField = "data";
final String valorField = "valor";
final String tipoField = "tipo";
final String descricaoField = "descricao";

class Movimentacoes {
  String id = "";
  String data = "";
  double valor = 0.0;
  String tipo = "";
  String descricao = "";

  Movimentacoes();

  Movimentacoes.fromMap(Map<String, dynamic> map) {
    id = map[idField];
    valor = map[valorField];
    data = map[dataField];
    tipo = map[tipoField];
    descricao = map[descricaoField];
  }

  Map<String, dynamic> toMap() {
    return {
      idField: id,
      valorField: valor,
      dataField: data,
      tipoField: tipo,
      descricaoField: descricao,
    };
  }

  @override
  String toString() {
    return "Movimentacoes(id: $id, valor: $valor, data: $data, tipo: $tipo, descricao: $descricao)";
  }
}

class MovimentacoesHelper {
  static final MovimentacoesHelper _instance = MovimentacoesHelper.internal();

  factory MovimentacoesHelper() => _instance;

  MovimentacoesHelper.internal();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada save");
    CollectionReference movimentacoesRef =
        _firestore.collection(movimentacaoCollection);
    movimentacoes.id = movimentacoesRef.doc().id;
    await movimentacoesRef.doc(movimentacoes.id).set(movimentacoes.toMap());
  }

  Future<Movimentacoes?> getMovimentacoes(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(movimentacaoCollection).doc(id).get();
    if (snapshot.exists) {
      return Movimentacoes.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> deleteMovimentacao(String id) async {
    await _firestore.collection(movimentacaoCollection).doc(id).delete();
  }

  Future<void> updateMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada update");
    print(movimentacoes.toString());
    await _firestore
        .collection(movimentacaoCollection)
        .doc(movimentacoes.id)
        .update(movimentacoes.toMap());
  }

  Future<List<Movimentacoes>> getAllMovimentacoes() async {
    QuerySnapshot snapshot =
        await _firestore.collection(movimentacaoCollection).get();
    List<Movimentacoes> listMovimentacoes = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      listMovimentacoes
          .add(Movimentacoes.fromMap(doc.data() as Map<String, dynamic>));
    }
    return listMovimentacoes;
  }

  Future<List<Movimentacoes>> getAllMovimentacoesPorMes(String data) async {
    DatabaseReference dbMovimentacoes = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = (await dbMovimentacoes
        .child(movimentacaoCollection)
        .orderByChild(dataField)
        .equalTo(data)
        .once()) as DataSnapshot;

    List<Movimentacoes> listMovimentacoes = [];

    Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;
    print(values);
    if (values != null) {
      values.forEach((key, map) {
        listMovimentacoes
            .add(Movimentacoes.fromMap(map as Map<String, dynamic>));
      });
    }

    return listMovimentacoes;
  }

  /*Future<List<Movimentacoes>> getAllMovimentacoesPorMes(String data) async {
    QuerySnapshot snapshot = await _firestore
        .collection(movimentacaoCollection)
        .where(dataField, isGreaterThanOrEqualTo: data)
        .where(dataField, isLessThan: data + 'z')
        .get();
    List<Movimentacoes> listMovimentacoes = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      listMovimentacoes
          .add(Movimentacoes.fromMap(doc.data() as Map<String, dynamic>));
    }
    return listMovimentacoes;
  }*/

  Future<List<Movimentacoes>> getAllMovimentacoesporDescricao(
      String data, String tipo) async {
    QuerySnapshot snapshot = await _firestore
        .collection(movimentacaoCollection)
        .where(dataField, isGreaterThanOrEqualTo: data)
        .where(dataField, isLessThan: data + 'z')
        .where(tipoField, isEqualTo: tipo)
        .get();
    List<Movimentacoes> listMovimentacoes = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      listMovimentacoes
          .add(Movimentacoes.fromMap(doc.data() as Map<String, dynamic>));
    }
    return listMovimentacoes;
  }

  Future<List<Movimentacoes>> getAllMovimentacoesPorTipo(String tipo) async {
    QuerySnapshot snapshot = await _firestore
        .collection(movimentacaoCollection)
        .where(tipoField, isEqualTo: tipo)
        .get();
    List<Movimentacoes> listMovimentacoes = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      listMovimentacoes
          .add(Movimentacoes.fromMap(doc.data() as Map<String, dynamic>));
    }
    return listMovimentacoes;
  }

  Future<int> getNumber() async {
    QuerySnapshot snapshot =
        await _firestore.collection(movimentacaoCollection).get();
    return snapshot.docs.length;
  }
}




/*import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String movimentacaoTABLE = "movimentacaoTABLE";
final String idColumn = "idColumn";
final String dataColumn = "dataColumn";
final String valorColumn = "valorColumn";
final String tipoColumn = "tipoColumn";
final String descricaoColumn = "descricaoColumn";

class Movimentacoes {
  int id = 0;
  String data = " ";
  double valor = 0.0;
  String tipo = " ";
  String descricao = " ";

  Movimentacoes();

  Movimentacoes.fromMap(Map map) {
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, Object?> map = {
      valorColumn: valor,
      dataColumn: data,
      tipoColumn: tipo,
      descricaoColumn: descricao,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  String toString() {
    return "Movimentaoes(id: $id, valor: $valor, data: $data, tipo: $tipo, desc: $descricao, )";
  }
}

class MovimentacoesHelper {
  static final MovimentacoesHelper _instance = MovimentacoesHelper.internal();

  factory MovimentacoesHelper() => _instance;

  MovimentacoesHelper.internal();

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
    final path = join(databasePath, "movimentacao.db");
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

  Future<Movimentacoes> saveMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada save");
    Database? dbMovimentacoes = await db;
    if (dbMovimentacoes != null) {
      int lastId = Sqflite.firstIntValue(await dbMovimentacoes
              .rawQuery('SELECT MAX(idColumn) FROM movimentacaoTABLE')) ??
          0;
      movimentacoes.id = lastId + 1;
      movimentacoes.id = await dbMovimentacoes.insert(
        movimentacaoTABLE,
        movimentacoes.toMap().cast<String, Object?>(),
      );
    } else {
      throw Exception("O banco de dados não está inicializado");
    }
    return movimentacoes;
  }

  Future<Movimentacoes?> getMovimentacoes(int id) async {
    Database? dbMovimentacoes = await db;
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
      return Movimentacoes.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int?> deleteMovimentacao(Movimentacoes movimentacoes) async {
    Database? dbMovimentacoes = await db;
    return await dbMovimentacoes?.delete(movimentacaoTABLE,
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<int> updateMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada update");
    print(movimentacoes.toString());
    Database? dbMovimentacoes = await db;
    return await dbMovimentacoes!.update(
        movimentacaoTABLE, movimentacoes.toMap().cast<String, Object?>(),
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<List> getAllMovimentacoes() async {
    Database? dbMovimentacoes = await db;
    List listMap =
        await dbMovimentacoes!.rawQuery("SELECT * FROM $movimentacaoTABLE");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorMes(String data) async {
    Database? dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%'");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesporDescricao(String data, String tipo) async {
    Database? dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%' AND $tipoColumn LIKE '%$tipo%'");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorTipo(String tipo) async {
    Database? dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes!.rawQuery(
        "SELECT * FROM $movimentacaoTABLE WHERE $tipoColumn ='$tipo' ");
    List<Movimentacoes> listMovimentacoes = [];

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<int?> getNumber() async {
    Database? dbMovimentacoes = await db;
    return Sqflite.firstIntValue(await dbMovimentacoes!
        .rawQuery("SELECT COUNT(*) FROM $movimentacaoTABLE"));
  }

  Future close() async {
    Database? dbMovimentacoes = await db;
    dbMovimentacoes!.close();
  }
}
*/