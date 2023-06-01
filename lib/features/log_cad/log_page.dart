import 'package:bellycoin_app/common/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/routes.dart';
import 'bottomCad.dart';
import 'bottomLog.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC966),
      body: Column(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: Color(0xFF737373),
            ),
            child: Image.asset(
              'assets/images/cad_log.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: Color(0xFFFFC966),
            ),
            child: Image.asset('assets/images/login 1.png'),
          )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: 286.0,
                height: 56.0,
                child: Log_bot(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: 286.0,
                height: 56.0,
                child: Cad_bot(),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 150,
                height: 59,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: MaterialStatePropertyAll<Color>(Colors.black),
                    elevation: MaterialStatePropertyAll(50),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xFFFFFFFF)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    signInWithGoogle().then((userCredential) {
                      if (userCredential != null) {
                        // Login bem-sucedido, redirecione para a próxima tela
                        Navigator.pushReplacementNamed(
                            context, NamedRoute.init);
                      } else {
                        // Tratamento de erro de login
                      }
                    });
                  },
                  child: Image.asset(
                    'assets/images/GIcon.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
              Text(
                '....',
                style:
                    AppTextStyles.smallText.copyWith(color: Color(0xFFFFC966)),
              ),
              SizedBox(
                width: 150,
                height: 59,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shadowColor: MaterialStatePropertyAll<Color>(Colors.black),
                    elevation: MaterialStatePropertyAll(50),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xFF3A559F)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Icon(
                    Icons.facebook,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      // Realizar a autenticação pelo Google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Autenticar com o Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential;
    } catch (error) {
      print('Erro durante o login com o Google: $error');
      return null;
    }
  }
}
