import 'package:cloud_firestore/cloud_firestore.dart';

final String metasCollection = "metasCollection";
final String idField = "id";
final String valorField = "valor";
final String dataField = "data";
final String descricaoField = "descricao";

class Metas {
  String id = "";
  double valor = 0.0;
  String data = "";
  String descricao = "";

  Metas();

  Metas.fromMap(Map<String, dynamic> map) {
    id = map[idField];
    valor = map[valorField];
    data = map[dataField];
    descricao = map[descricaoField];
  }

  Map<String, dynamic> toMap() {
    return {
      idField: id,
      valorField: valor,
      dataField: data,
      descricaoField: descricao,
    };
  }

  @override
  String toString() {
    return "Metas(id: $id, valor: $valor, data: $data, descricao: $descricao)";
  }
}

class MetasHelper {
  static final MetasHelper _instance = MetasHelper.internal();

  factory MetasHelper() => _instance;

  MetasHelper.internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMetas(Metas metas) async {
    print("chamada save");
    CollectionReference metasRef = _firestore.collection(metasCollection);
    metas.id = metasRef.doc().id;
    await metasRef.doc(metas.id).set(metas.toMap());
  }

  Future<Metas?> getMetas(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(metasCollection).doc(id).get();
    if (snapshot.exists) {
      return Metas.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updateMetas(Metas metas) async {
    print("chamada update");
    print(metas.toString());
    await _firestore
        .collection(metasCollection)
        .doc(metas.id)
        .update(metas.toMap());
  }

  Future<List<Metas>> getAllMetasMes(String data) async {
    QuerySnapshot snapshot = await _firestore
        .collection(metasCollection)
        .where(dataField, isGreaterThanOrEqualTo: data)
        .where(dataField, isLessThan: data + 'z')
        .get();
    List<Metas> listMetas = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      listMetas.add(Metas.fromMap(doc.data() as Map<String, dynamic>));
    }
    return listMetas;
  }
}



