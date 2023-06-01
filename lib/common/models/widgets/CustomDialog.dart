import 'package:bellycoin_app/repositories/auxTransactionsSQL.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/Transactions.dart';

class CustomDialog extends StatefulWidget {
  final Movimentacoes? mov;
  final auxMovimentacoes? aux;
  const CustomDialog({Key? key, this.mov, this.aux}) : super(key: key);
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  late bool edit;

  int _groupValueRadio = 1;
  Color _colorContainer = Color(0xFF545454);
  Color _colorTextButtom = Color(0xFFBB8331);
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDesp = TextEditingController();
  TextEditingController _controllerRec = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();

  final MovimentacoesHelper _movHelper = MovimentacoesHelper();
  final auxMovimentacoesHelper _auxmovHelper = auxMovimentacoesHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.mov != null) {
      print(widget.mov.toString());

      edit = true;
      if (widget.mov?.tipo == "d") {
        _groupValueRadio = 2;
        _colorContainer = Color(0xFF545454);
        _colorTextButtom = Color(0xFFBB8331);
        _controllerDesp.text = widget.mov!.valor.toString().replaceAll("-", "");
      } else {
        _controllerRec.text = widget.mov!.valor.toString().replaceAll("-", "");
      }

      _controllerValor.text = widget.mov!.valor.toString().replaceAll("-", "");
      _controllerDesc.text = widget.mov!.descricao;
    } else {
      edit = false;
    }
    print(" edit -> $edit");
    if (_groupValueRadio == 1) {
      _controllerRec = _controllerValor;
    } else if (_groupValueRadio == 2) {
      _controllerDesp = _controllerValor;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.050)),
        title: Text(
          "Adicionar Valores",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _colorContainer,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "R\$ ",
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.06),
                  ),
                  Flexible(
                    child: TextField(
                        controller: _controllerValor,
                        maxLength: 7,
                        style: TextStyle(fontSize: width * 0.05),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        decoration: new InputDecoration(
                          hintText: "0.00",
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding: EdgeInsets.only(
                              left: width * 0.04,
                              top: width * 0.041,
                              bottom: width * 0.041,
                              right: width * 0.04), //15),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        )),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: Color(0xFFBB8331),
                    value: 1,
                    groupValue: _groupValueRadio,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _groupValueRadio = value!;
                        _colorContainer = Color(0xFF545454);
                        _colorTextButtom = Color(0xFFBB8331);
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("receita"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: Color(0xFFBB8331),
                    value: 2,
                    groupValue: _groupValueRadio,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _groupValueRadio = value!;
                        _colorContainer = Color(0xFF545454);
                        _colorTextButtom = Color(0xFFBB8331);
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("despesa"),
                  )
                ],
              ),
              TextField(
                  controller: _controllerDesc,
                  maxLength: 20,
                  style: TextStyle(fontSize: width * 0.05),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  decoration: new InputDecoration(
                    //hintText: "descrição",
                    labelText: "Descrição",
                    labelStyle: TextStyle(color: Colors.white54),
                    //hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: width * 0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controllerValor.text.isNotEmpty &&
                            _controllerDesc.text.isNotEmpty) {
                          Movimentacoes mov = Movimentacoes();
                          auxMovimentacoes aux = auxMovimentacoes();
                          String valor;
                          if (_controllerValor.text.contains(",")) {
                            valor = _controllerValor.text
                                .replaceAll(RegExp(","), ".");
                          } else {
                            valor = _controllerValor.text;
                          }

                          mov.data = formatter.format(DateTime.now());
                          aux.date = formatter.format(DateTime.now());
                          mov.descricao = _controllerDesc.text;
                          aux.descr = _controllerDesc.text;

                          if (_groupValueRadio == 1) {
                            mov.valor = double.parse(valor);
                            aux.value = double.parse(valor);
                            mov.tipo = "r";
                            aux.type = "r";
                            if (widget.mov != null) {
                              mov.id = widget.mov!.id;
                              aux.ident = widget.aux!.ident;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                            edit == false
                                ? _auxmovHelper.auxsaveMovimentacao(aux)
                                : _auxmovHelper.auxsaveMovimentacao(aux);
                          }
                          if (_groupValueRadio == 2) {
                            mov.valor = double.parse("-" + valor);
                            aux.value = double.parse("-" + valor);
                            mov.tipo = "d";
                            aux.type = "d";
                            if (widget.mov != null) {
                              mov.id = widget.mov!.id;
                              aux.ident = widget.aux!.ident;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                            edit == false
                                ? _auxmovHelper.auxsaveMovimentacao(aux)
                                : _auxmovHelper.auxsaveMovimentacao(aux);
                          }
                          Navigator.pop(context);
                          //initState();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            edit == false ? "Confirmar" : "Editar",
                            style: TextStyle(
                                color: _colorTextButtom,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
