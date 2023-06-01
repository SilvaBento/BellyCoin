import 'package:bellycoin_app/features/homePageView/Goals/GoalsScream.dart';
import 'package:bellycoin_app/features/homePageView/Home/HomeScream.dart';
import 'package:bellycoin_app/features/homePageView/Statis/StatisticScream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/models/widgets/AnimatedBottomNavBar.dart';
import '../../common/routes.dart';

class InicialPage extends StatefulWidget {
  final List<BarItem> barItems = [
    BarItem(
      text: "Metas",
      iconData: Icons.wallet,
      color: Color(0xFFBB8331),
    ),
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: Color(0xFFBB8331),
    ),
    BarItem(
      text: "Estatisticas",
      iconData: Icons.stacked_line_chart_sharp,
      color: Color(0xFFBB8331),
    ),
  ];

  @override
  _InicialPageState createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  int selectedBarIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool _showFab = true;
    bool _isVisible = true;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //systemNavigationBarColor: Colors.lightBlue[700], // navigation bar color
        //statusBarColor: Colors.lightBlue[700],
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light // status bar color
        ));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    List<Widget> telas = [GoalsSC(), HomeSc(), StatisSC()];

    //_allMov();
    //print("\nMes atual: " + DateTime.now().month.toString());
    return Scaffold(
      body: telas[selectedBarIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(fontSize: width * 0.045, iconSize: width * 0.07),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                _logout();
              },
              tooltip: 'Logout',
              backgroundColor: Color(0xFFBB8331),
              elevation: _isVisible ? 0.0 : null,
              child: const Icon(Icons.logout),
            )
          : null,
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, NamedRoute.logCad);
  }
}
