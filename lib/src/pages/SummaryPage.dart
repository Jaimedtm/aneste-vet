import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/models/Summary.dart';
import 'package:vetcalc/src/models/animal.dart';
import 'package:vetcalc/src/medicamentos/Fluidoterapia.dart';
import 'package:vetcalc/src/widgets/CustomHeader.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BouncingScrollPhysics _physics = BouncingScrollPhysics();
    Size screen = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        var resp = await _onWillpop(context, screen);
        if (resp) Navigator.of(context).popAndPushNamed('seleccion');
        return Future.value(false);
      },
      child: Scaffold(
          body: Container(
        height: screen.height,
        width: screen.width,
        child: SingleChildScrollView(
          physics: _physics,
          child: Stack(
            children: [
              _main(context, screen),
              CurveHeaderSummary(onPress: () async {
                final resp = await _onWillpop(context, screen);
                if (resp) Navigator.of(context).popAndPushNamed('seleccion');
              }),
            ],
          ),
        ),
      )),
    );
  }

  Widget _main(BuildContext context, Size screen) {
    return Column(
      children: [
        SizedBox(
          height: screen.height * 0.16,
        ),
        Container(
          //height: screen.height * 0.75,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screen.width,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      Summary().animal.name,
                      style: _style(screen, null, 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Animal: ${Summary().animalString}',
                        style: _style(screen),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Peso: ${Summary().animal.weight}Kg',
                        style: _style(screen),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  Text(
                    'Genero: ${Summary().animalGenero}',
                    style: _style(screen),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _medication(context, screen),
                  Summary().fluidoterapia == null
                      ? Container()
                      : _fluidoterapia(screen)
                ],
              ),
            ),
          ),
        ),
        Container(
          width: screen.width,
          height: screen.height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screen.height * 0.12,
                child: Image.asset('res/img/cat_banner.png'),
              ),
              kIsWeb
                  ? Container(
                      height: 50,
                      width: screen.width * 0.333,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Imprimir',
                            style: _style(screen, Colors.white),
                          ),
                        ),
                        onPressed: () {
                          //TODO:js.context.callMethod('print');
                          js.context.callMethod('print');
                        },
                      ),
                    )
                  : Container(
                      width: 0,
                    ),
              Container(
                height: screen.height * 0.12,
                child: Image.asset('res/img/dog_banner.png'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _medication(BuildContext context, Size screen) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: Summary().inform.length,
        itemBuilder: (context, index) {
          bool _isAnalgesic = Summary().inform[index].type == Selections.analgesic;
          String dose = '${Summary().inform[index].doseString}';

          if (_isAnalgesic) {
            if (Summary().inform[index].name == 'Meloxicam') {
              if (Summary().animal is Dog) {
                dose = dose == '0.2mg/kg' ? dose + ' solo 1er día' : dose;
              }
            } else if (Summary().inform[index].name == 'Carprofeno') {
              if (Summary().animal is Dog) {
                dose += ' 1 o 2 veces al día';
              }
            }
          }

          return Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screen.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  _calculo(Summary().inform[index].type),
                  style: _style(screen, null, 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Farmaco: ${Summary().inform[index].name}',
                style: _style(screen),
              ),
              Text(
                'Concentración: ${Summary().inform[index].concentration}',
                style: _style(screen),
              ),
              Text(
                'Dosis: $dose',
                style: _style(screen),
              ),
              Text(
                'Dosis total en mg: ${Summary().inform[index].mgTotales}mg',
                style: _style(screen),
              ),
              Text(
                'Dosis total en ml: ${Summary().inform[index].dosisTotalML}ml',
                style: _style(screen),
              ),
              _isAnalgesic
                  ? Text(
                      'Efecto secundario Gastrointestinal',
                      style: _style(screen),
                    )
                  : Container(height: 0),
              Summary().inform.length > 1 && Summary().inform.length - 1 != index
                  ? Divider(
                      color: Colors.black54,
                      thickness: 3,
                      height: 20,
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ));
        });
  }

  Widget _fluidoterapia(Size screen) {
    final Fluidoterapia fl = Summary().fluidoterapia;
    double perdida;
    if (fl.perdidaSensible > 0) perdida = fl.perdidaSensible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Summary().inform.length > 0
            ? Divider(
                color: Colors.black54,
                thickness: 3,
                height: 20,
              )
            : Container(
                height: 0,
              ),
        Container(
          width: screen.width,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            'Fluidoterapia',
            style: _style(screen, null, 20),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          'Gotero: ${fl.goteroString}',
          style: _style(screen),
        ),
        Text(
          'ml administrar: ${fl.mlAdministrar}ml',
          style: _style(screen),
        ),
        Text(
          'ml de mantenimiento: ${fl.mlMantenimiento}ml',
          style: _style(screen),
        ),
        perdida == null
            ? Container(
                height: 0,
              )
            : Text(
                'Perdida sensible: ${perdida.toString()}ml',
                style: _style(screen),
              ),
        Container(
          width: screen.width,
          height: 80,
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green,
                width: 2,
              )),
          child: Text(
            'ml totales en 24Hrs: ${fl.mlTotales24hrs}ml\nGotas por hora: ${fl.gotasHora} gotas.',
            style: _style(screen),
          ),
        )
      ],
    );
  }

  TextStyle _style(Size screen,
      [Color color = Colors.black, double fontSize = 16.5]) {
    fontSize = screen.width > 350 ? fontSize : fontSize - 2;
    return GoogleFonts.montserrat(fontSize: fontSize, color: color);
  }

  Future<bool> _onWillpop(BuildContext context, Size screen) async {
    bool resp = true;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(
                '¿Qué deseas hacer? ',
                style: _style(screen, null, 20),
                textAlign: TextAlign.center,
              ),
              content: Text(
                '''Si selecciona “Finalizar” regresará a la pantalla principal, los datos y cálculos se perderán.
                \nSi selecciona “Editar” volverá a la pagina de selección''',
                style: _style(screen),
                textAlign: TextAlign.justify,
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    'Cancelar',
                    style: _style(screen, Colors.red[600]),
                  ),
                  onPressed: () {
                    resp = false;
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text(
                    'Editar',
                    style: _style(screen, Colors.amber[900]),
                  ),
                  onPressed: () {
                    resp = true;
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                    child: Text(
                      'Finalizar',
                      style: _style(screen, Colors.blue[300]),
                    ),
                    onPressed: () {
                      resp = false;
                      Summary().reset();
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    })
              ],
            ));
    return resp;
  }

  String _calculo(Selections type) {
    String result;
    switch (type) {
      case Selections.opioid:
        result = 'Opioide';
        break;
      case Selections.inductor:
        result = 'Inductor';
        break;
      case Selections.premedication:
        result = 'Premedicación';
        break;
      case Selections.analgesic:
        result = 'Analgésico';
        break;
      case Selections.fluidtherapy:
        result = 'Fluidoterapia';
        break;
    }
    return result;
  }
}
