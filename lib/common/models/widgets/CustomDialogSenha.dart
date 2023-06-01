import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../repositories/Transactions.dart';
import '../../app_text_styles.dart';

class LosePass extends StatefulWidget {
  final Movimentacoes? pass;
  const LosePass({Key? key, this.pass}) : super(key: key);

  @override
  State<LosePass> createState() => _LosePassState();
}

class _LosePassState extends State<LosePass> {
  final _formKey = GlobalKey<FormState>();

  String? Function(String?)? validator;

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: _formKey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Recuperar senha",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF545454)),
      ),
      backgroundColor: Color(0xFFA8A8A8),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 135,
              height: 8,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Color(0xFF545454)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Container(
                    height: 2,
                    width: 135,
                  )),
            ),
            SizedBox(height: 16),
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
                color: Color(0xFF545454),
              ),
              decoration: InputDecoration(
                  labelText: 'Email:',
                  labelStyle: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 20,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF545454),
                      width: 8,
                    ),
                  ),
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  prefixIconColor: Color(0xFF545454)),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 286.0,
              height: 56.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  shadowColor: MaterialStatePropertyAll<Color>(Colors.black),
                  elevation: MaterialStatePropertyAll(50),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xFF545454)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: () {
                  _formKey.currentState?.validate();
                  resetPassword(_emailController.text);
                },
                child: Text('ENVIAR',
                    style: AppTextStyles.midText.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
