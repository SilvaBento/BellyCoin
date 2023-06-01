import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/models/widgets/CardMovimentacoesItem.dart';
import '../../../common/models/widgets/CustomDialog.dart';
import '../../../common/routes.dart';
import '../../../repositories/Transactions.dart';
import '../../../repositories/auxTransactionsSQL.dart';

class HomeSc extends StatefulWidget {
  @override
  _HomeScState createState() => _HomeScState();
  const HomeSc({super.key});
}

class _HomeScState extends State<HomeSc> {
  String saldo = "";
  String despesas = " ";
  String receitas = " ";
  var total;
  var totalR;
  var totalD;
  var width;
  var height;
  bool recDesp = false;
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  auxMovimentacoesHelper auxmovimentacoesHelper = auxMovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];
  List<Movimentacoes> listmovimentacoesD = [];
  List<Movimentacoes> listmovimentacoesR = [];
  List<auxMovimentacoes> auxList = [];
  List<Movimentacoes> ultimaTarefaRemovida = [];

  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String dataFormatada = " ";

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _valorController = TextEditingController();

  void _addValor() {
    String valor = _valorController.text;
    setState(() {
      saldo = valor;
    });
  }

  _saldoTamanho(String conteudo) {
    if (conteudo.length > 8) {
      return width * 0.08;
    } else {
      return width * 0.1;
    }
  }

  _salvar() {
    dataFormatada = formatter.format(dataAtual);
    Movimentacoes mov = Movimentacoes();
    mov.valor = 20.50;
    mov.tipo = "r";
    mov.data = "03-05-2023"; //dataFormatada;
    mov.descricao = "CashBack";
    MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
    movimentacoesHelper.saveMovimentacao(mov);
    mov.toString();
  }

  _allMov() {
    movimentacoesHelper.getAllMovimentacoes().then((list) {
      if (list.isNotEmpty) {
        setState(() async {
          listmovimentacoes = List<Movimentacoes>.from(list);
          print("All MovMes: $listmovimentacoes");
        });
      }
    });
  }

  _allMovMes(String data) {
    auxmovimentacoesHelper.getAllMovimentacoesPorMesSQL(data).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          auxList = List<auxMovimentacoes>.from(list);
          total =
              auxList.map((item) => item.value).reduce((a, b) => a + b);
        });
        print("All MovMes: $auxList");
        saldo = format(total).toString();
        print("All saldo: $saldo");
      } else {
        setState(() {
          auxList.clear();
          total = 0;
          saldo = total.toString();
        });
      }
    });
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoesR = List<Movimentacoes>.from(list);
          totalR = listmovimentacoesR
              .map((item) => item.valor)
              .reduce((a, b) => a + b);
        });
        print("All Mov: $listmovimentacoesR");
        receitas = format(totalR).toString();
      } else {
        setState(() {
          listmovimentacoesR.clear();
          totalR = 0;
          receitas = totalR.toString();
        });
      }
    });
  }

  _allMovPorTipo2() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      if (list.iterator.moveNext()) {
        setState(() {
          listmovimentacoesD = List<Movimentacoes>.from(list);
          totalD = listmovimentacoesD
              .map((item) => item.valor)
              .reduce((a, b) => a + b);
        });
        print("All Mov: $listmovimentacoesD");
        despesas = format(totalD).toString();
      } else {
        setState(() {
          listmovimentacoesD.clear();
          totalD = 0;
          despesas = totalD.toString();
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
    _allMov();
    _allMovMes(dataFormatada);
    _allMovPorTipo();
    _allMovPorTipo2();
  }

  _dialogAddRecDesp() {
    showDialog(
        context: context,
        builder: (context) {
          return const CustomDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    _allMovMes(dataFormatada);
    //_allMov();
    return Scaffold(
      backgroundColor: Color(0xFF545454),
      key: _scafoldKey,
      body: SingleChildScrollView(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        //physics: ClampingScrollPhysics(),
        //height: height,
        //width: width,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: height * 0.334, //300,
                  color: Color(0xFF545454),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.09,
                        top: width * 0.04,
                        bottom: width * 0.02,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, NamedRoute.rec);
                        },
                        child: Container(
                          width: width * 0.10,
                          height: width * 0.10, //65,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFC966), //Colors.indigo[400],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.logout,
                            size: width * 0.07,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    width: double.infinity,
                    height: height * 0.28, //250,
                    decoration: BoxDecoration(
                        color: Color(0xFFFFC966),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF545454),
                              blurRadius: 5,
                              offset: Offset(0, 2))
                        ]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: width * 0.07, // 30,
                  right: width * 0.07, // 30,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),

                    height: height * 0.22, //150,
                    width: width * 0.2, // 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF545454),
                              blurRadius: 5,
                              offset: Offset(0, 2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.05,
                            top: width * 0.04,
                            bottom: width * 0.02,
                          ),
                          child: Text(
                            "Total",
                            style: TextStyle(
                                color: Color(0xFF545454),
                                fontSize: width * 0.05),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.05),
                              child: Container(
                                width: width * 0.6,
                                child: Text(
                                  saldo,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Color(0xFFBB8331), //Colors.indigo[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: _saldoTamanho(saldo),
                                    //width * 0.1 //_saldoTamanho(saldoAtual)
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.04),
                              child: GestureDetector(
                                onTap: () {
                                  _dialogAddRecDesp();
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddReceita()));
                                 */
                                },
                                child: Container(
                                  width: width * 0.12,
                                  height: width * 0.12, //65,
                                  decoration: BoxDecoration(
                                      color: Color(
                                          0xFFBB8331), //Colors.indigo[400],
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF545454),
                                          blurRadius: 7,
                                          offset: Offset(2, 2),
                                        )
                                      ]),
                                  child: Icon(
                                    Icons.add,
                                    size: width * 0.07,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.008,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.136),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: height * 0.01, //150,
                            width: width * 0.9, // 70,
                            decoration: BoxDecoration(
                              color: Color(0xFF545454),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.09,
                                top: width * 0.04,
                                bottom: width * 0.02,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, NamedRoute.rec);
                                },
                                child: Container(
                                  width: width * 0.10,
                                  height: width * 0.10, //65,
                                  decoration: BoxDecoration(
                                    color: Colors.white, //Colors.indigo[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.arrow_circle_up_sharp,
                                    size: width * 0.07,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              receitas,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF545454), //Colors.indigo[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                //width * 0.1 //_saldoTamanho(saldoAtual)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.09,
                                top: width * 0.04,
                                bottom: width * 0.02,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, NamedRoute.dep);
                                },
                                child: Container(
                                  width: width * 0.10,
                                  height: width * 0.10, //65,
                                  decoration: BoxDecoration(
                                    color: Colors.white, //Colors.indigo[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.arrow_circle_down_sharp,
                                    size: width * 0.07,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              despesas,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF545454), //Colors.indigo[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                //width * 0.1 //_saldoTamanho(saldoAtual)
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),

              width: width * 0.9, // 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF545454),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: TableCalendar(
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(outsideDaysVisible: false),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.transparent),
                  weekendStyle: TextStyle(color: Colors.transparent),
                ),
                rowHeight: 0,
                firstDay: DateTime.utc(2023, 01, 01),
                lastDay: DateTime.utc(2023, 12, 31),
                focusedDay: _selectedDate,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    dataFormatada = formatterCalendar.format(selectedDay);
                    //_allMovMes(dataFormatada);
                    print("DATA FORMATADA CALENDAR $dataFormatada");
                  });
                },
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Movimentações",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.04),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: Icon(
                        Icons.sort,
                        size: width * 0.07,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.04, right: width * 0.04, top: 0),
              child: SizedBox(
                width: width,
                height: height * 0.47,
                child: ListView.builder(
                  itemCount: listmovimentacoes.length,
                  itemBuilder: (context, index) {
                    Movimentacoes mov = listmovimentacoes[index];
                    Movimentacoes ultMov = listmovimentacoes[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        //_dialogConfimacao(context, width, mov,index);

                        setState(() {
                          listmovimentacoes.removeAt(index);
                        });
                        movHelper.deleteMovimentacao(mov.id);
                        final snackBar = SnackBar(
                          content: Container(
                            padding: EdgeInsets.only(bottom: width * 0.025),
                            alignment: Alignment.bottomLeft,
                            height: height * 0.05,
                            child: Text(
                              "Desfazer Ação",
                              style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: width * 0.05),
                            ),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.orange[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          action: SnackBarAction(
                            label: "Desfazer",
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                listmovimentacoes.insert(index, ultMov);
                              });

                              movHelper.saveMovimentacao(ultMov);
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      key: ValueKey(mov.id),
                      background: Container(
                        padding: EdgeInsets.only(right: 10, top: width * 0.04),
                        alignment: Alignment.topRight,
                        color: Colors.red,
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: width * 0.07,
                        ),
                      ),
                      child: CardMovimentacoesItem(
                        mov: mov,
                        lastItem:
                            listmovimentacoes[index] == listmovimentacoes.last
                                ? true
                                : false,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("EEEEEEEEE"),
            )
          ],
        ),
      ),
    );
  }
}
