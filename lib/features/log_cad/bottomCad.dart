import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/app_text_styles.dart';
import '../../common/models/widgets/custom_circular_progress_indicator.dart';
import '../../common/routes.dart';

class Cad_bot extends StatefulWidget {
  const Cad_bot({super.key});

  @override
  State<Cad_bot> createState() => _Cad_botState();
}

class _Cad_botState extends State<Cad_bot> {
  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFFFFC966)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 3.0, color: Colors.white),
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
                        controller: _nameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome Obriatorio';
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFFFC966),
                        ),
                        decoration: InputDecoration(
                            labelText: 'Nome:',
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
                            prefixIcon: Icon(Icons.fingerprint),
                            prefixIconColor: Color(0xFFFFC966)),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Obriatorio';
                          }
                        },
                        keyboardType: TextInputType.text,
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
                        keyboardType: TextInputType.text,
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
                          Cad_bot();
                        },
                        child: Text('Já possui uma conta ?',
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
                            final valid = _formKey.currentState != null &&
                                _formKey.currentState!.validate();
                            cadastrar();
                            if (valid) {
                            } else {
                              print("erro ao logar");
                            }
                          },
                          child: Text('CADASTRE-SE',
                              style: AppTextStyles.midText
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                      Image.asset('assets/images/CadImage.png'),
                    ],
                  ),
                ),
              );
            });
      },
      child: Text('CADASTRE-SE',
          style: AppTextStyles.midText.copyWith(color: Colors.white)),
    );
  }

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nameController.text);
        CustomCircularProgressIndicator;
        Navigator.pushReplacementNamed(context, NamedRoute.init);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Crie uma senha mais forte'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este email já foi cadastrado'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }
}
