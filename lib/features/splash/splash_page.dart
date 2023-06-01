import 'dart:async';

import 'package:bellycoin_app/common/models/widgets/custom_circular_progress_indicator.dart';
import 'package:bellycoin_app/common/routes.dart';
import 'package:flutter/material.dart';

import '../onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Timer init() {
    return Timer(
      Duration(seconds: 4),
      navigatetoOnboardig,
    );
  }

  void navigatetoOnboardig() {
    Navigator.pushReplacementNamed(context, NamedRoute.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF737373),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/images/logo.png'),
            ),
            Center(child: CustomCircularProgressIndicator()),
          ],
        ));
  }
}
