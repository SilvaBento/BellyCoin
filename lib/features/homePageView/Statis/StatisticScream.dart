import 'package:bellycoin_app/common/models/widgets/CustomPieChartRec.dart';
import 'package:bellycoin_app/common/models/widgets/customBarChart.dart';
import 'package:flutter/material.dart';

import '../../../common/models/widgets/CustomPieChart.dart';

class StatisSC extends StatefulWidget {
  const StatisSC({super.key});

  @override
  State<StatisSC> createState() => _StatisSCState();
}

class _StatisSCState extends State<StatisSC> {
  var width;
  var height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF545454),
      body: SingleChildScrollView(
        primary: false,
        physics: AlwaysScrollableScrollPhysics(),
        //physics: ClampingScrollPhysics(),
        //height: height,
        //width: width,
        child: Column(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: height * 0.14, //250,
                decoration: BoxDecoration(
                    color: Color(0xFFBB8331),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFF545454),
                          blurRadius: 5,
                          offset: Offset(0, 2))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBB8331),
                  ),
                  margin: EdgeInsets.only(top: 50, bottom: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.stacked_line_chart_sharp,
                        color: Colors.white,
                      ),
                      Text(
                        "Estatisticas",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white, //Colors.indigo[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          //width * 0.1 //_saldoTamanho(saldoAtual)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              height: 230,
              width: 380,
              decoration: BoxDecoration(
                  color: Color(0xFF303030),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF545454),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: Center(
                child: GraficoFinanceiro(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 230,
              width: 380,
              decoration: BoxDecoration(
                  color: Color(0xFF303030),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF545454),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: GraficoDespesas(),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 230,
              width: 380,
              decoration: BoxDecoration(
                  color: Color(0xFF303030),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF545454),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: GraficoReceitas(),
            ),
          ],
        ),
      ),
    );
  }
}
