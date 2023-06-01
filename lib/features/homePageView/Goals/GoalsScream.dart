import 'package:bellycoin_app/common/models/widgets/RadioBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/models/widgets/CustomDialogGoals.dart';
import '../../../repositories/Transactions.dart';

class GoalsSC extends StatefulWidget {
  const GoalsSC({super.key});

  @override
  State<GoalsSC> createState() => _GoalsSCState();
}

class _GoalsSCState extends State<GoalsSC> {
  var width;
  var height;
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = [];
  List<Movimentacoes> ultimaTarefaRemovida = [];

  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String dataFormatada = " ";

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _dialogAddRecDesp() {
    showDialog(
        context: context,
        builder: (context) {
          return const CustomGoals();
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
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF545454),
      body: Column(
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
                      Icons.wallet,
                      color: Colors.white,
                    ),
                    Text(
                      "Metas",
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
          TableCalendar(
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
          Padding(
            padding: EdgeInsets.only(right: width * 0.04),
            child: GestureDetector(
              onTap: () {
                _dialogAddRecDesp();
              },
              child: Container(
                width: 380,
                height: width * 0.12, //65,
                decoration: BoxDecoration(
                    color: Color(0xFFFFC966), //Colors.indigo[400],
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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFF303030),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF545454),
                        blurRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: RadioGoals(),
            ),
          ),
        ],
      ),
    );
  }
}
