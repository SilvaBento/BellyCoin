import 'package:flutter/material.dart';

import '../../../common/models/widgets/TimeLineItem.dart';
import '../../../common/routes.dart';
import '../../../repositories/Transactions.dart';

class DespesasResumo extends StatefulWidget {
  @override
  _DespesasResumoState createState() => _DespesasResumoState();
}

class _DespesasResumoState extends State<DespesasResumo> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      setState(() {
        listmovimentacoes = List<Movimentacoes>.from(list);
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allMovPorTipo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05, top: width * 0.2),
              child: Text(
                "Despesas",
                style: TextStyle(
                    color: Colors.white, //Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.08),
              ),
            ),
            SizedBox(
              width: 135,
              height: 8,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xFF5E1B16)),
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, NamedRoute.init),
                  child: Container(
                    height: 2,
                    width: 135,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  itemCount: listmovimentacoes.length,
                  itemBuilder: (context, index) {
                    List movReverse = listmovimentacoes.reversed.toList();
                    Movimentacoes mov = movReverse[index];

                    if (movReverse[index] == movReverse.last) {
                      return TimeLineItem(
                        mov: mov,
                        colorItem: Color(0xFF5E1B16),
                        isLast: true,
                      );
                    } else {
                      return TimeLineItem(
                        mov: mov,
                        colorItem: const Color.fromARGB(255, 94, 27, 22),
                        isLast: true,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
