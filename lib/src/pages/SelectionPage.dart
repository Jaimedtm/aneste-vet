import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/pages/Drugpage.dart';
import 'package:vetcalc/src/pages/FluidoPage.dart';
import 'package:vetcalc/src/pages/SummaryPage.dart';
import 'package:vetcalc/src/widgets/CustomHeader.dart';
import 'package:vetcalc/src/widgets/CustomImageButton.dart';
import 'package:vetcalc/src/models/Summary.dart';
import 'package:vetcalc/src/widgets/SlidePageRoute.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key key}) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: screen.height,
        width: screen.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: _toShow(screen, context),
                ),
              ),
            ),
            CurveHeader(
              title: 'Selección',
              colors: [Color(0xFF169E6C), Color(0xFFB1EA6B)],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _toShow(Size screen, BuildContext context) {
    Function _update = () {
      setState(() {});
    };
    List<Widget> _list = [
      SizedBox(
        height: screen.height * 0.16,
      ),
      CustomImageButton(
          key: Key('FLTRP'),
          title: 'Fluidoterapia',
          imgPath: 'res/img/fluido_btn.png',
          colors: [Color(0xFFB9FF2D), Color(0xFF46F9AF)],
          onPress: () => Navigator.of(context).push(SlidePageRoute(FluidoPage(
                callback: _update,
              )))),
      SizedBox(
        key: Key('FLTRP_S'),
        height: 10,
      ),
      CustomImageButton(
          key: Key('PRMD'),
          title: 'Cálculo Premedicación',
          imgPath: 'res/img/med_btn.png',
          colors: [Color(0xFFFFC64A), Color(0xFFFFAA80)],
          onPress: () {
            Navigator.of(context).push(SlidePageRoute(DrugPage(
              callback: _update,
              titel: 'Premedicación',
              drugType: Selections.premedication,
              colors: [Color(0xFFFFAA80), Color(0xFFFFC64A)],
            )));
          }),
      SizedBox(
        key: Key('PRMD_S'),
        height: 10,
      ),
      CustomImageButton(
          key: Key('OPIOD'),
          title: 'Cálculo Opioides',
          imgPath: 'res/img/med_btn.png',
          colors: [Color(0xFFFF2D83), Color(0xFFFF8097)],
          onPress: () {
            Navigator.of(context).push(SlidePageRoute(DrugPage(
              callback: _update,
              titel: 'Opioides',
              drugType: Selections.opioid,
              colors: [Color(0xFFFF2D83), Color(0xFFFF8097)],
            )));
          }),
      SizedBox(
        key: Key('OPIOD_S'),
        height: 10,
      ),
      CustomImageButton(
          key: Key('ANALG'),
          title: 'Cálculo Analgésicos',
          imgPath: 'res/img/med_btn.png',
          colors: [Color(0xFFC92DFF), Color(0xFFFF83A7)],
          onPress: () {
            Navigator.of(context).push(SlidePageRoute(DrugPage(
              callback: _update,
              titel: 'Analgésicos',
              drugType: Selections.analgesic,
              colors: [Color(0xFFC92DFF), Color(0xFFFF83A7)],
            )));
          }),
      SizedBox(
        key: Key('ANALG_S'),
        height: 10,
      ),
      CustomImageButton(
          key: Key('INDTR'),
          title: 'Cálculo Inductores',
          imgPath: 'res/img/med_btn.png',
          colors: [Color(0xFFFF511F), Color(0xFFFFB166)],
          onPress: () {
            Navigator.of(context).push(SlidePageRoute(DrugPage(
              callback: _update,
              titel: 'Inductores',
              drugType: Selections.inductor,
              colors: [Color(0xFFFF511F), Color(0xFFFFB166)],
            )));
          }),
      SizedBox(
        key: Key('INDTR_S'),
        height: 10,
      ),
      Container(
        width: screen.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 10,
              child: Container(
                height: 50,
                width: screen.width / 2,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Colors.green,
                    onPressed: Summary().inform.length > 0 ||
                            Summary().fluidoterapia != null
                        ? () {
                            Navigator.of(context)
                                .push(SlidePageRoute(SummaryPage()));
                          }
                        : null,
                    child: Text(
                      'Finalizar',
                      style:
                          GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 10,
              child: Container(
                height: 50,
                width: screen.width / 2,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Colors.amber[900],
                    onPressed: Summary().inform.length > 0 ||
                            Summary().fluidoterapia != null
                        ? () => _edit(screen)
                        : null,
                    child: Text(
                      'Editar',
                      style:
                          GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
                    )),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ];
    if (Summary().selections.contains(Selections.fluidtherapy)) {
      _list.removeWhere((element) => element.key.toString() == "[<'FLTRP'>]");
      _list.removeWhere((element) => element.key.toString() == "[<'FLTRP_S'>]");
    }
    if (Summary().selections.contains(Selections.opioid)) {
      _list.removeWhere((element) => element.key.toString() == "[<'OPIOD'>]");
      _list.removeWhere((element) => element.key.toString() == "[<'OPIOD_S'>]");
    }
    if (Summary().selections.contains(Selections.inductor)) {
      _list.removeWhere((element) => element.key.toString() == "[<'INDTR'>]");
      _list.removeWhere((element) => element.key.toString() == "[<'INDTR_S'>]");
    }
    if (Summary().selections.contains(Selections.premedication)) {
      _list.removeWhere((element) => element.key.toString() == "[<'PRMD'>]");
      _list.removeWhere((element) => element.key.toString() == "[<'PRMD_S'>]");
    }
    if (Summary().selections.contains(Selections.analgesic)) {
      _list.removeWhere((element) => element.key.toString() == "[<'ANALG'>]");
      _list.removeWhere((element) => element.key.toString() == "[<'ANALG_S'>]");
    }
    return _list;
  }

  _edit(Size screen) async {
    Function _update = () {
      setState(() {});
    };
    List<InformerDrug> informerList = Summary().inform;
    List<List<Color>> colors = [
      [Color(0xFFFF2D83), Color(0xFFFF8097)],
      [Color(0xFFFF511F), Color(0xFFFFB166)],
      [Color(0xFFFFC64A), Color(0xFFFFAA80)],
      [Color(0xFFC92DFF), Color(0xFFFF83A7)],
      [Color(0xFFB9FF2D), Color(0xFF46F9AF)],
    ];
    List<String> titles = [
      'Opioide',
      'Inductores',
      'Premedicación',
      'Analgésicos',
      'Fluidoterapia'
    ];
    int indexSelections = informerList.length;
    if (Summary().fluidoterapia != null) indexSelections++;
    dynamic resp;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Qué cálculo deseas editar? ',
          style: _style(screen, null, 20),
          textAlign: TextAlign.center,
        ),
        content: Container(
            child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: indexSelections,
          itemBuilder: (BuildContext context, int i) {
            if (Summary().fluidoterapia != null && i == indexSelections - 1) {
              return InkWell(
                onTap: () {
                  resp = true;
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: screen.height / 20,
                  alignment: Alignment.center,
                  child: Text(
                    titles[4],
                    style: _style(screen, Color(0xFF724BB4), 18),
                  ),
                ),
              );
            } else {
              return InkWell(
                onLongPress: () async {
                  bool condition = informerList[i].type == Selections.opioid &&
                          Summary().inform.any((drug) => drug.name == 'Ketamina') ||
                      informerList[i].name == 'Ketamina';
                  await HapticFeedback.vibrate();
                  if (condition) {
                    Summary().deleteSelection(Selections.opioid);
                    Summary().deleteSelection(Selections.inductor);
                  } else {
                    Summary().deleteSelection(informerList[i].type);
                  }
                  Navigator.of(context).pop();
                },
                onTap: () {
                  resp = informerList[i];
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: screen.height / 20,
                  alignment: Alignment.center,
                  child: Text(
                    informerList[i].name,
                    style: _style(screen, Color(0xFF724BB4), 18),
                  ),
                ),
              );
            }
          },
        )),
      ),
    ).then((_) {
      if (resp is InformerDrug) {
        Navigator.of(context).push(SlidePageRoute(DrugPage(
          toEdit: true,
          titel: titles[resp.type.index],
          drugType: resp.type,
          colors: colors[resp.type.index],
          callback: _update,
        )));
      } else if (resp is bool) {
        if (resp) {
          Navigator.of(context).push(SlidePageRoute(FluidoPage(
            callback: _update,
            toEdit: true,
          )));
        }
      } else {
        setState(() {});
      }
    });
  }

  TextStyle _style(Size screen,
      [Color color = Colors.black, double fontSize = 16.5]) {
    fontSize = screen.width > 350 ? fontSize : fontSize - 2;
    return GoogleFonts.montserrat(fontSize: fontSize, color: color);
  }
}
