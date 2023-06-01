import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../repositories/Transactions.dart';

class GraficoFinanceiro extends StatefulWidget {
  @override
  _GraficoFinanceiroState createState() => _GraficoFinanceiroState();
}

class _GraficoFinanceiroState extends State<GraficoFinanceiro> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];
  var totalD;
  var totalR;
  var total;
  String rec = 'Receitas';
  String desp = 'Despesa';
  String saldo = 'Saldo';
  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoes = List<Movimentacoes>.from(list);
          totalD = listmovimentacoes
              .map((item) => item.valor.abs())
              .reduce((a, b) => a + b);
        });
      }
    });
  }

  _allMovPorTipoR() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoes = List<Movimentacoes>.from(list);
          totalR = listmovimentacoes
              .map((item) => item.valor.abs())
              .reduce((a, b) => a + b);
        });
      }
    });
  }

  _allMov() {
    movimentacoesHelper.getAllMovimentacoes().then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoes = List<Movimentacoes>.from(list);
          total = listmovimentacoes
              .map((item) => item.valor)
              .reduce((a, b) => a + b);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _allMovPorTipo();
    _allMovPorTipoR();
    _allMov();
  }

  @override
  Widget build(BuildContext context) {
    List<_SalesData> salesDataList = [
      _SalesData(rec, totalR, Colors.green),
      _SalesData(desp, totalD, Colors.red),
      _SalesData(saldo, total, Color(0xFFFFC966)),
    ];
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <BarSeries<_SalesData, String>>[
        BarSeries<_SalesData, String>(
          dataSource: salesDataList,
          xValueMapper: (_SalesData data, _) => data.tipo,
          yValueMapper: (_SalesData data, _) => data.valor,
          pointColorMapper: (_SalesData data, _) => data.cor,
        ),
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.tipo, this.valor, this.cor);

  final String tipo;
  final double valor;
  final Color cor;
}
