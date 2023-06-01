import 'package:bellycoin_app/common/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../common/routes.dart';

final loading = ValueNotifier<bool>(false);

class OnbordingPage extends StatelessWidget {
  final bool isLoggedIn;
  const OnbordingPage({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC966),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: new BoxDecoration(
                  color: Color(0xFF737373),
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF303030),
                        blurRadius: 25.0,
                        spreadRadius: 8.0,
                        offset: Offset(2.0, 5.0)),
                  ]),
              child: Image.asset(
                'assets/images/logo.png',
                height: 250.0,
                width: 250.0,
              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBB8331),
                      ),
                      child: AnimatedBuilder(
                        animation: loading,
                        builder: (context, _) {
                          return loading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('ENTER');
                        },
                      ),
                      onPressed: () {
                        isLoggedIn
                            ? Navigator.pushReplacementNamed(
                                context, NamedRoute.init)
                            : Navigator.pushReplacementNamed(
                                context, NamedRoute.logCad);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text('BELLY COIN',
              style: AppTextStyles.bigText.copyWith(color: Color(0xFF737373))),
          Text('Seu gerenciador de finanças pessoal',
              style:
                  AppTextStyles.smallText.copyWith(color: Color(0xFF737373))),
          Text('        ', style: AppTextStyles.bigText)
        ],
      ),
    );
  }
}
