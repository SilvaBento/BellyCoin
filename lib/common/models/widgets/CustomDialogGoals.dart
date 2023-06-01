import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/TransactionsGoals.dart';
import '../../../repositories/auxTrasactionsGoals.dart';

class CustomGoals extends StatefulWidget {
  final Metas? metas;
  final auxMetas? auxM;
  const CustomGoals({Key? key, this.metas, this.auxM}) : super(key: key);
  @override
  _CustomGoalsState createState() => _CustomGoalsState();
}

class _CustomGoalsState extends State<CustomGoals> {
  var formatter = new DateFormat('dd-MM-yyyy');
  late bool edit;

  Color _colorContainer = Color(0xFF545454);
  Color _colorTextButtom = Color(0xFFBB8331);
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();

  final MetasHelper _metasHelper = MetasHelper();
  final auxMetasHelper _auxmetasHelper = auxMetasHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.metas != null) {
      print(widget.metas.toString());

      edit = true;
      _controllerValor.text =
          widget.metas!.valor.toString().replaceAll("-", "");
      _controllerDesc.text = widget.metas!.descricao;
    } else {
      edit = false;
    }
    print(" edit -> $edit");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.050)),
        title: Text(
          "Adicionar Metas",
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
                          Metas metas = Metas();
                          auxMetas auxM = auxMetas();
                          String valor = _controllerValor.text
                              .replaceAll(RegExp(","), ".");
                          metas.valor = double.parse(valor);
                          auxM.valorM = double.parse(valor);
                          metas.data = formatter.format(DateTime.now());
                          auxM.dataM = formatter.format(DateTime.now());
                          metas.descricao = _controllerDesc.text;
                          auxM.descricaoM = _controllerDesc.text;
                          if (widget.metas != null) {
                            metas.id = widget.metas!.id;
                            auxM.idM = widget.auxM!.idM;
                          }
                          edit == false
                              ? _metasHelper.saveMetas(metas)
                              : _metasHelper.updateMetas(metas);
                          edit == false
                              ? _auxmetasHelper.saveMetas(auxM)
                              : _auxmetasHelper.updateMetas(auxM);
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
