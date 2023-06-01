import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../repositories/Transactions.dart';

class GraficoReceitas extends StatefulWidget {
  const GraficoReceitas({super.key});

  @override
  State<GraficoReceitas> createState() => _GraficoReceitasState();
}

class _GraficoReceitasState extends State<GraficoReceitas> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];
  List<String> lista = [];
  List<double> valores = [];
  var totalR;
  String receitas = " ";
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoes = List<Movimentacoes>.from(list);
          lista = listmovimentacoes.map((item) => item.descricao).toList();
          valores = listmovimentacoes.map((item) => item.valor).toList();
          totalR = listmovimentacoes
              .map((item) => item.valor)
              .reduce((a, b) => a + b);
        });
        print("All Mov: $listmovimentacoes");
        receitas = format(totalR).toString();
      }
    });
  }

  final colorList = <Color>[
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();

    _allMovPorTipo();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {};
    for (int i = 0; i < lista.length; i++) {
      String chave = lista[i];
      double valor = valores[i];

      if (dataMap.containsKey(chave)) {
        dataMap[chave] =
            dataMap[chave]! + valor; // Soma o valor ao valor existente na chave
        print(dataMap);
      } else {
        dataMap[chave] = valor; // Adiciona uma nova chave-valor ao mapa
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 230,
      width: 380,
      decoration: BoxDecoration(
          color: Color(0xFF303030),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF545454), blurRadius: 5, offset: Offset(0, 2))
          ]),
      child: Center(
        child: Column(
          children: [
            Text(
              "Receitas",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              colorList: [
                Color(0xFF2DD132),
                Color(0xFF0F4911),
                Color(0xFF7FD582),
                Color(0xFF252E25),
                Color(0xFFACE2AE),
                Color(0xFF6FFF74),
                Color(0xFF6A866B),
                Color(0xFF012E02),
                Color(0xFF1B201C),
              ],
              centerText: receitas,
              centerTextStyle: TextStyle(
                color: Color(0xFF0F4911),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              baseChartColor: Colors.grey,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              legendOptions: LegendOptions(
                legendPosition: LegendPosition.right,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValuesOutside: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
