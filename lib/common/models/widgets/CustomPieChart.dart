import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../repositories/Transactions.dart';

class GraficoDespesas extends StatefulWidget {
  const GraficoDespesas({super.key});

  @override
  State<GraficoDespesas> createState() => _GraficoDespesasState();
}

class _GraficoDespesasState extends State<GraficoDespesas> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];
  List<String> lista = [];
  List<double> valores = [];
  var totalD;
  String despesas = " ";
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoes = List<Movimentacoes>.from(list);
          lista = listmovimentacoes.map((item) => item.descricao).toList();
          valores = listmovimentacoes.map((item) => item.valor).toList();
          totalD = listmovimentacoes
              .map((item) => item.valor.abs())
              .reduce((a, b) => a + b);
        });
        print("All Mov: $listmovimentacoes");
        despesas = format(totalD).toString();
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
      double valor = valores[i].abs();

      if (dataMap.containsKey(chave)) {
        dataMap[chave] =
            dataMap[chave]! + valor; // Soma o valor ao valor existente na chave
        print(dataMap);
      } else {
        dataMap[chave] = valor; // Adiciona uma nova chave-valor ao mapa
      }
    }
    return Center(
      child: Column(
        children: [
          Text(
            "Despesas",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          PieChart(
            dataMap: dataMap,
            chartType: ChartType.ring,
            colorList: [
              Colors.red,
              Color(0xFF9D2A22),
              Color(0xFFFF8880),
              Color(0xFF520F0A),
              Color(0xFF975C57),
              Color(0xFF411C19),
              Color(0xFF310401),
              Color(0xFF60413F),
              Color(0xFF483B3A),
            ],
            centerText: despesas,
            centerTextStyle: TextStyle(
              color: Color(0xFF9D2A22),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            baseChartColor: Colors.grey,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            legendOptions: LegendOptions(
              legendPosition: LegendPosition.left,
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
    );
  }
}
