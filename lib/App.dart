import 'package:bellycoin_app/features/homePageView/Goals/GoalsScream.dart';
import 'package:bellycoin_app/features/homePageView/Home/DespesasResumo.dart';
import 'package:bellycoin_app/features/homePageView/Home/HomeScream.dart';
import 'package:bellycoin_app/features/homePageView/Home/ReceitasResumo.dart';
import 'package:bellycoin_app/features/homePageView/Statis/StatisticScream.dart';
import 'package:bellycoin_app/features/log_cad/log_page.dart';
import 'package:bellycoin_app/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'common/routes.dart';
import 'features/homePageView/homePage.dart';
import 'features/onboarding/onboarding_page.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: NamedRoute.splash, routes: {
      NamedRoute.initial: (context) => OnbordingPage(isLoggedIn: isLoggedIn),
      NamedRoute.splash: (context) => const SplashPage(),
      NamedRoute.logCad: (context) => const loginScreen(),
      NamedRoute.init: (context) => InicialPage(),
      NamedRoute.homes: (context) => const HomeSc(),
      NamedRoute.rec: (context) => ReceitasResumo(),
      NamedRoute.dep: (context) => DespesasResumo(),
      NamedRoute.stats: (context) => const StatisSC(),
      NamedRoute.goals: (context) => const GoalsSC(),
    });
  }
}
