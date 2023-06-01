import 'package:bellycoin_app/repositories/auxTransactionsSQL.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../repositories/Transactions.dart';
import '../../../repositories/auxTrasactionsGoals.dart';

class RadioGoals extends StatefulWidget {
  const RadioGoals({super.key});

  @override
  State<RadioGoals> createState() => _RadioGoalsState();
}

class DescDados {
  String descricao = " ";
  double valor = 0.0;

  DescDados(this.descricao, this.valor);

  String toString() {
    return "DescDados(desc: $descricao, valor: $valor)";
  }
}

class RadialDados {
  String descricao = " ";
  double valor = 0.0;
  String texto = " ";
  Color color;

  RadialDados(this.descricao, this.valor, this.texto, this.color);

  String toString() {
    return "RadialDados(desc: $descricao, valor: $valor,texto: $texto,)";
  }
}

class _RadioGoalsState extends State<RadioGoals> {
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  auxMovimentacoesHelper movimentacoesHelper = auxMovimentacoesHelper();
  auxMetasHelper metasHelper = auxMetasHelper();

  List<auxMovimentacoes> listmovimentacoes = [];
  List<auxMovimentacoes> ultimaTarefaRemovida = [];
  List<auxMetas> listmetas = [];
  List<String> desc = [];
  List<DescDados> valorMetas = [];
  List<String> descricao = [];
  List<double> valores = [];
  List<RadialDados> radialDados = [];
  List<dynamic> colorRadial = [
    Color(0xFF75592F),
    Color(0xFFBB8331),
    Color(0xFFD39E4E),
    Color(0xFF7C6645),
    Color(0xFFD78810),
    Color(0xFF4F3919),
    Color(0xFF865307),
    Color(0xFFD9B888),
    Color(0xFF8F7A5B),
    Color(0xFF403421),
    Color(0xFFFFA929),
    Color(0xFFFF9900),
  ];

  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String dataFormatada = " ";
  String descForm = "";

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMetasDesc(String data) {
    metasHelper.getAllMetasMes(data).then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmetas = List<auxMetas>.from(list);
          desc = listmetas.map((item) => item.descricaoM).toList();
          print("All mestas mes: $listmetas");
          print("All descricos: $desc");
        });
      }
    });
  }

  _allMovDesc(String data) {
    movimentacoesHelper.getAllMovimentacoesPorMesSQL(data).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          movimentacoesHelper
              .getAllMovimentacoesPorMesSQL(data)
              .then((list) {});
          listmovimentacoes = List<auxMovimentacoes>.from(list);
          if (desc.any((item) => listmovimentacoes
              .map((item) => item.descr)
              .toList()
              .contains(item))) {
            descForm = desc.firstWhere((item) => listmovimentacoes
                .map((item) => item.descr)
                .toList()
                .contains(item));
          }
        });
      }
    });
  }

  _allMovMes(String data, String desc) {
    movimentacoesHelper
        .getAllMovimentacoesporDescricaoSQL(data, "d")
        .then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = List<auxMovimentacoes>.from(list);
          descricao = listmovimentacoes.map((item) => (item.descr)).toList();
          valores = listmovimentacoes.map((item) => (item.value)).toList();

          Map<String, double> dataMap = {};
          for (int i = 0; i < descricao.length; i++) {
            String chave = descricao[i];
            double valor = valores[i].abs();

            if (dataMap.containsKey(chave)) {
              dataMap[chave] = dataMap[chave]! +
                  valor; // Soma o valor ao valor existente na chave
              print(dataMap);
            } else {
              dataMap[chave] = valor; // Adiciona uma nova chave-valor ao mapa
            }
          }

          dataMap.forEach((descricao, valor) {
            DescDados dado = DescDados(descricao, valor);
            valorMetas.add(dado);
          });

          print("All valorMetas: $valorMetas");
        });
      } else {
        setState(() {
          listmovimentacoes.clear();
          print("All valorMetas: $valorMetas");
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (DateTime.now().month != null) {
      // saldoAtual = "1259";
    }
    //_salvar();
    dataFormatada = formatterCalendar.format(dataAtual);
    print(dataFormatada);
    _allMetasDesc(dataFormatada);
    _allMetasDesc(dataFormatada);
    _allMovMes(dataFormatada, descForm);
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < listmetas.length; i++) {
      String descricaoMetas = listmetas[i].descricaoM;
      double metasValor = listmetas[i].valorM.abs();
      double valorDescDados = 0.0;
      String texto = "";

      for (int j = 0; j < valorMetas.length; j++) {
        if (valorMetas[j].descricao == descricaoMetas) {
          valorDescDados = valorMetas[j].valor.abs();
          break;
        }
      }
      dynamic radialcores = colorRadial[i];
      double resultado = metasValor - valorDescDados;
      texto =
          "${listmetas[i].descricaoM}\nMeta: ${listmetas[i].valorM}\nGastos: ${valorMetas[i].valor}\n";

      if (valorDescDados >= metasValor) {
        resultado = 0.0;
        texto =
            "${listmetas[i].descricaoM}\nMeta: ${listmetas[i].valorM}\nGastos: Excedidos\n";
      }

      radialDados
          .add(RadialDados(descricaoMetas, resultado, texto, radialcores));
      print("Dados : $radialDados");
    }
    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        iconHeight: 25,
        iconWidth: 50,
        borderWidth: 20,
        position: LegendPosition.bottom,
        // Configurações adicionais da legenda
        textStyle: TextStyle(fontSize: 18, color: Colors.white),
        overflowMode: LegendItemOverflowMode.scroll,
        shouldAlwaysShowScrollbar: true, isResponsive: true,
        backgroundColor: Color(0xFF303030),
      ),
      series: <CircularSeries>[
        // Renders radial bar chart
        RadialBarSeries<RadialDados, String>(
          dataSource: radialDados,
          xValueMapper: (RadialDados data, _) => data.texto,
          yValueMapper: (RadialDados data, _) => data.valor.abs(),
          pointColorMapper: (RadialDados data, _) => data.color,
          trackColor: Color(0xFFA4A1A1),
          trackBorderColor: Color(0x00000000),
          enableTooltip: true,
          animationDuration: 1000,
          radius: '180',
          maximumValue: 2000,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
