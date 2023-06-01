import 'package:bellycoin_app/common/models/widgets/CustomDialogSenha.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/app_text_styles.dart';
import '../../common/routes.dart';

class Log_bot extends StatefulWidget {
  const Log_bot({super.key});

  @override
  State<Log_bot> createState() => _Log_botState();
}

class _Log_botState extends State<Log_bot> {
  _dialogPass() {
    showDialog(
        context: context,
        builder: (context) {
          return const LosePass();
        });
  }

  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
  String? Function(String?)? validator;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shadowColor: MaterialStatePropertyAll<Color>(Colors.black),
        elevation: MaterialStatePropertyAll(50),
        backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF737373)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            )),
            backgroundColor: Color(0xFF737373),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: 135,
                        height: 8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color(0xFF545454)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Container(
                              height: 2,
                              width: 135,
                            )),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Obriatorio';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFFFC966),
                        ),
                        decoration: InputDecoration(
                            labelText: 'Email:',
                            labelStyle: TextStyle(
                              color: Color(0xFFFFC966),
                              fontSize: 20,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFC966),
                                width: 8,
                              ),
                            ),
                            prefixIcon: Icon(Icons.supervised_user_circle),
                            prefixIconColor: Color(0xFFFFC966)),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Senha Obriatoria';
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFFFC966),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Senha:',
                          labelStyle: TextStyle(
                            color: Color(0xFFFFC966),
                            fontSize: 20,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFFC966),
                              width: 8,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFFFFC966),
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              _showPass == false
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFFFFC966),
                            ),
                            onTap: () {
                              setState(() {
                                _showPass = !_showPass;
                              });
                            },
                          ),
                        ),
                        obscureText: _showPass == false ? true : false,
                      ),
                      TextButton(
                        onPressed: () {
                          _dialogPass();
                        },
                        child: Text('Esqueceu sua senha ?',
                            style: TextStyle(
                              color: Color(0xFFFFC966),
                            )),
                      ),
                      SizedBox(
                        width: 286.0,
                        height: 56.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shadowColor:
                                MaterialStatePropertyAll<Color>(Colors.black),
                            elevation: MaterialStatePropertyAll(50),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xFFFFC966)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _formKey.currentState?.validate();
                            login();
                          },
                          child: Text('LOGIN',
                              style: AppTextStyles.midText
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                      Image.asset('assets/images/pigImage.png'),
                    ],
                  ),
                ),
              );
            });
      },
      child: Text('LOGIN',
          style: AppTextStyles.midText.copyWith(color: Colors.white)),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;
      FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (userCredential != null) {
        Navigator.pushReplacementNamed(context, NamedRoute.init);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuário não encontrado'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Senha incorreta'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }
}
