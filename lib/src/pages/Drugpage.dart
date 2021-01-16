import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/models/Summary.dart';
import 'package:vetcalc/src/models/animal.dart';
import 'package:vetcalc/src/medicamentos/CalculosAnestesico.dart';
import 'package:vetcalc/src/pages/SummaryPage.dart';
import 'package:vetcalc/src/util/dataLists.dart';
import 'package:vetcalc/src/util/globalMethods.dart';
import 'package:vetcalc/src/widgets/CustomCardSlider.dart';
import 'package:vetcalc/src/widgets/CustomDropDown.dart';
import 'package:vetcalc/src/widgets/CustomHeader.dart';
import 'package:vetcalc/src/widgets/SlidePageRoute.dart';

typedef SelectionValue = void Function();

class DrugPage extends StatefulWidget {
  final String titel;
  final List<Color> colors;
  final Selections drugType;
  final SelectionValue callback;
  final bool toEdit;
  const DrugPage(
      {Key key,
      this.colors,
      this.titel = 'Titulo',
      this.drugType,
      this.callback,
      this.toEdit = false})
      : super(key: key);

  @override
  _DrugPageState createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  int valueConcentration = 0;
  bool _alternativeDose = false;
  bool _alternativeConsentration = false;
  bool _mgOrug = false;
  bool _division = false;
  bool _firtsDay = true;
  double maxDose;
  double minDose;
  String _pharmac;
  Size screen;
  DrugModel _drug;
  List<String> _concentrations = [];
  List<String> _items;
  ValueNotifier<String> _notifier = ValueNotifier<String>('');
  ValueNotifier<double> _notifierSlider = ValueNotifier<double>(1);
  TextEditingController _doseController = TextEditingController();
  TextEditingController _mgController = TextEditingController();
  TextEditingController _mlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    _notifierSlider.dispose();
    _doseController.dispose();
    _mgController.dispose();
    _mlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cases();
    screen = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: screen.height,
      width: screen.width,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                height: screen.height,
                width: screen.width,
                child: SingleChildScrollView(child: _main())),
          ),
          CurveHeader(
            title: widget.titel,
            colors: widget.colors,
          ),
          Positioned(
            top: Summary().isCompleted()
                ? screen.height - 60
                : ((screen.height / 2) - 30),
            child: _buttons(),
            height: Summary().isCompleted() ? 60 : screen.height,
            width: screen.width,
          )
        ],
      ),
    ));
  }

  void cases() {
    switch (widget.drugType) {
      case Selections.opioid:
        _drug = Opioide(Summary().animalString);
        _items = opioides;
        break;
      case Selections.inductor:
        bool _premed = Summary().selections.contains(Selections.premedication);
        _drug = FarmacoInductor(Summary().animalString, _premed);
        _items = _premed ? inductoresPremed : inductores;
        break;
      case Selections.premedication:
        _drug = Premedicacion();
        _items = premed;
        break;
      case Selections.analgesic:
        _drug = Analgesia(Summary().animalString);
        _items = analgesicos;
        break;
      case Selections.fluidtherapy:
        break;
    }
  }

  Widget _main() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: screen.height * 0.15,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          width: screen.width - screen.width * 0.13,
          child: CustomDropDown(
            screen: screen,
            value: _pharmac,
            items: _items,
            color: widget.colors[1],
            onChanged: (value) async {
              await onDropChange(value);
            },
          ),
        ),
        SizedBox(
          height: screen.height * 0.025,
        ),
        ValueListenableBuilder<double>(
          valueListenable: _notifierSlider,
          builder: (context, value, child) {
            if (_pharmac != null && !_alternativeDose && _analgesicConditions()) {
              if (Summary().animal is Dog) {
                if (_pharmac == 'Meloxicam') {
                  if (_firtsDay)
                    _notifierSlider.value = 200;
                  else
                    _notifierSlider.value = 100;
                  return Container(
                    width: screen.width,
                    height: screen.height * 0.18,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Dosis de 0.2mg/kg para el primer día\nDosis de 0.1mg/kg para días sucesivos',
                            style: _style(null, 14),
                          ),
                        ),
                        SizedBox(
                          height: screen.height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Primer día', style: _style(null)),
                            Checkbox(
                                value: _firtsDay,
                                activeColor: widget.colors[1],
                                onChanged: (value) {
                                  setState(() {
                                    _firtsDay = value;
                                    if (_firtsDay)
                                      _notifierSlider.value = 200;
                                    else
                                      _notifierSlider.value = 100;
                                  });
                                })
                          ],
                        )
                      ],
                    )),
                  );
                } else {
                  return _sliderCons();
                }
              } else {
                if (_pharmac == 'Meloxicam') {
                  _notifierSlider.value = 300;
                  return Container(
                    width: screen.width,
                    height: screen.height * 0.125,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: Center(
                        child: Text(
                          'Dosis unica de 0.3mg/kg',
                          style: _style(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return _sliderCons();
                }
              }
            } else if (_pharmac != null && !_alternativeDose) {
              return _sliderCons();
            } else if (_pharmac != null && _alternativeDose) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Text(
                        'Dosis: ${mgOrmcg(_notifierSlider.value)}',
                        style: GoogleFonts.montserrat(fontSize: 18),
                      ),
                      SizedBox(
                        height: screen.height * 0.025,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Theme(
                          data: ThemeData(primaryColor: widget.colors[1]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 6,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 180),
                                  height: 50,
                                  child: TextField(
                                    onChanged: (value) {
                                      _division = false;
                                      _mgOrug = false;
                                      _notifierSlider.value = double.parse(value);
                                    },
                                    controller: _doseController,
                                    style: GoogleFonts.montserrat(fontSize: 18),
                                    keyboardType: TextInputType.numberWithOptions(
                                        decimal: true),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        hintStyle:
                                            GoogleFonts.montserrat(fontSize: 18),
                                        hintText: 'Dosis',
                                        errorStyle: null,
                                        errorText:
                                            _isValidValue(_notifierSlider.value)),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Container(
                                  //padding: EdgeInsets.only(top: ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: widget.colors[1],
                                        value: _mgOrug,
                                        onChanged: (value) {
                                          setState(() {});
                                          _mgOrug = value;
                                          _onMgOrUg();
                                        },
                                      ),
                                      Text('µg/kg',
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  screen.width > 350 ? 18 : 15))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        _pharmac != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dosis personalizada',
                    style: GoogleFonts.montserrat(fontSize: 18),
                  ),
                  Checkbox(
                      activeColor: widget.colors[1],
                      value: _alternativeDose,
                      onChanged: (value) {
                        _alternativeDose = value;
                        if (value)
                          _notifierSlider.value = 0;
                        else
                          _notifierSlider.value = minDose;
                        setState(() {});
                      })
                ],
              )
            : Container(),
        SizedBox(
          height: screen.height * 0.015,
        ),
        ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (context, value, child) {
            if (_pharmac != null && !_alternativeConsentration) {
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: CustomCardSlider(
                  onChange: (value) {
                    valueConcentration = value;
                  },
                  colors: widget.colors,
                  concentrations: _concentrations,
                ),
              );
            } else if (_pharmac != null) {
              return Theme(
                data: ThemeData(primaryColor: widget.colors[1]),
                child: Container(
                  height: screen.height * 0.30,
                  width: screen.width,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _concentrationCustom(),
                    ),
                  ),
                ),
              );
            } else
              return Container();
          },
        ),
        _pharmac != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Concentración personalizada',
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  Checkbox(
                      activeColor: widget.colors[1],
                      value: _alternativeConsentration,
                      onChanged: (value) {
                        _alternativeConsentration = value;
                        if (value) {
                          _mgController.text = '0';
                          _mlController.text = '0';
                        }
                        setState(() {});
                      })
                ],
              )
            : Container(),
        SizedBox(
          height: 70,
        )
      ],
    );
  }

  List<Widget> _concentrationCustom() {
    return [
      Text(
        'Concentració: ${_mgController.text} mg/${_mlController.text} ml',
        style: GoogleFonts.montserrat(fontSize: 18),
      ),
      Container(
        constraints: BoxConstraints(maxWidth: 180),
        height: 50,
        child: TextField(
          onChanged: (value) {},
          controller: _mgController,
          style: GoogleFonts.montserrat(fontSize: 18),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintStyle: GoogleFonts.montserrat(fontSize: 18),
              hintText: 'mg',
              errorStyle: null,
              errorText: _isValidValue(double.parse(_mgController.text))),
        ),
      ),
      Container(
        constraints: BoxConstraints(maxWidth: 180),
        height: 50,
        child: TextField(
          onChanged: (value) {},
          controller: _mlController,
          style: GoogleFonts.montserrat(fontSize: 18),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintStyle: GoogleFonts.montserrat(fontSize: 18),
              hintText: 'ml',
              errorStyle: null,
              errorText: _isValidValue(double.parse(_mlController.text))),
        ),
      ),
    ];
  }

  Widget _buttons() {
    bool _disableButton = _pharmac == null;
    Function _finalize = () {
      _addToSummary();
      Navigator.of(context).push(SlidePageRoute(SummaryPage()));
    };

    if (_alternativeDose) {
      _disableButton |= _notifierSlider.value == 0;
    }
    if (_alternativeConsentration) {
      _disableButton |= _mgController.text == '' ||
          _mgController.text == null ||
          _mgController.text == '0';
      _disableButton |= _mlController.text == '' ||
          _mlController.text == null ||
          _mlController.text == '0';
    }

    if (Summary().isCompleted()) {
      return Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 60,
              width: screen.width / 2,
              child: FlatButton(
                  disabledColor: Colors.grey.withOpacity(0.7),
                  color: widget.colors[1],
                  onPressed: _disableButton
                      ? null
                      : () {
                          _addToSummary();
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    'Volver y editar',
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17),
                  )),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: 60,
              width: screen.width / 2,
              child: FlatButton(
                  disabledColor: Colors.grey.withOpacity(0.7),
                  color: widget.colors[0],
                  onPressed: _disableButton ? null : _finalize,
                  child: Text(
                    'Finalizar',
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
                  )),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 60,
              width: screen.width / 2,
              child: FlatButton(
                  disabledColor: Colors.grey.withOpacity(0.7),
                  color: widget.colors[1],
                  onPressed: _disableButton
                      ? null
                      : () {
                          _addToSummary();
                          widget.callback();
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    widget.toEdit ? 'Actualizar' : 'Añadir Cálculo',
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
                  )),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: 60,
              width: screen.width / 2,
              child: FlatButton(
                  disabledColor: Colors.grey.withOpacity(0.7),
                  color: widget.colors[0],
                  onPressed: _disableButton ? null : _finalize,
                  child: Text(
                    'Finalizar',
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
                  )),
            ),
          ),
        ],
      );
    }
  }

  void _addToSummary() {
    if (widget.toEdit) Summary().deleteSelection(widget.drugType);
    String concent = '${_mgController.text}mg/${_mlController.text}ml';
    double dose = _notifierSlider.value;
    if (!_alternativeConsentration) concent = _concentrations[valueConcentration];
    Summary().selections.add(widget.drugType);
    Summary().inform.add(InformerDrug(_pharmac, concent, widget.drugType, dose));
  }

  String _isValidValue(double value) {
    if (value == null)
      return 'Campo vacio';
    else if (value == 0)
      return 'El valor no puede ser igual a 0';
    else
      return null;
  }

  Future<void> onDropChange(String value) async {
    final bool condition = _drug is FarmacoInductor &&
        !Summary().selections.contains(Selections.opioid) &&
        value == 'Ketamina';
    if (condition)
      _alert();
    else {
      await _drug.init(value);
      maxDose = _drug.dosisMax * 1000;
      minDose = _drug.dosisMin * 1000;
      _notifierSlider.value = _drug.dosisMin * 1000;
      _concentrations = _drug.concentraciones;
      _pharmac = value;
      setState(() {});
    }
  }

  void _onMgOrUg() {
    if (_notifierSlider.value != 0 || _notifierSlider.value != null) {
      if (!_division) {
        _notifierSlider.value *= _mgOrug ? 0.001 : 1;
        _division = !_division;
      } else {
        _notifierSlider.value *= 1000;
        _division = !_division;
      }
    }
  }

  Widget _slider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 55,
      width: screen.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.colors[1],
            inactiveTrackColor: widget.colors[1].withOpacity(0.5),
            inactiveTickMarkColor: Colors.white38,
            thumbShape: SliderTumbShape(25, widget.colors[0]),
            overlayColor: Colors.transparent,
            trackHeight: 7),
        child: Slider(
          value: _notifierSlider.value,
          label: mgOrmcg((fixValue(_notifierSlider.value / 1000))),
          divisions: _sliderDivision(),
          min: minDose,
          max: maxDose,
          onChanged: (value) {
            _notifierSlider.value = double.parse(value.toStringAsFixed(2));
          },
        ),
      ),
    );
  }

  Widget _ajusteFino() {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFF99C542)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Ajuste fino',
              style: _style(),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.remove,
                          color: _notifierSlider.value > minDose
                              ? Colors.red
                              : Colors.grey,
                        ),
                        Container(
                          height: 30,
                          child: OutlineButton(
                              borderSide: BorderSide(width: 2, color: Colors.red),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              onPressed: _notifierSlider.value > minDose
                                  ? () {
                                      double multiplier = 1;
                                      if (_notifierSlider.value >= 1000)
                                        multiplier *= 100;
                                      _notifierSlider.value -= 0.1 * multiplier;
                                      _notifierSlider.value =
                                          (_notifierSlider.value * 100)
                                              .roundToDouble();
                                      _notifierSlider.value /= 100;
                                    }
                                  : null),
                        ),
                      ],
                    )),
                Container(
                    height: 30,
                    width: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: _notifierSlider.value < maxDose
                              ? widget.colors[0]
                              : Colors.grey,
                        ),
                        Container(
                          height: 30,
                          child: OutlineButton(
                              borderSide:
                                  BorderSide(width: 2, color: widget.colors[0]),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              onPressed: _notifierSlider.value < maxDose
                                  ? () {
                                      double multiplier = 1;
                                      if (_notifierSlider.value >= 1000)
                                        multiplier *= 100;
                                      else if (_notifierSlider.value >= 100)
                                        multiplier *= 10;
                                      _notifierSlider.value += 0.1 * multiplier;
                                      _notifierSlider.value =
                                          (_notifierSlider.value * 100)
                                              .roundToDouble();
                                      _notifierSlider.value /= 100;
                                    }
                                  : null),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _style([Color color = Colors.black, double fontSize = 17]) {
    fontSize = screen.width > 350 ? fontSize : fontSize - 2;
    return GoogleFonts.montserrat(fontSize: fontSize, color: color);
  }

  int _sliderDivision() {
    int resp = (maxDose - minDose).floor();
    if (resp > 999) resp = (resp / 10).floor();
    if (resp < 100) resp *= 10;
    return resp;
  }

  bool _analgesicConditions() {
    bool result = _drug is Analgesia;
    result &= _pharmac == 'Meloxicam' || _pharmac == 'Carprofeno';
    return result;
  }

  Widget _sliderCons() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          children: [
            Text(
              'Dosis: ${mgOrmcg(fixValue(_notifierSlider.value / 1000))}',
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            _slider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min: ${mgOrmcg(minDose / 1000)}',
                    style: GoogleFonts.montserrat(),
                  ),
                  Text(
                    'Max: ${mgOrmcg(maxDose / 1000)}',
                    style: GoogleFonts.montserrat(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _ajusteFino()
          ],
        ),
      ),
    );
  }

  void _alert() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Text(
                'Alerta',
                style: _style(Colors.orange[800], 20),
                textAlign: TextAlign.center,
              ),
              content: Text(
                'La “Ketamina” no puede ser seleccionada a menos que se añada un opioide previamente a los cálculos.',
                style: _style(null, 18),
                textAlign: TextAlign.justify,
              ),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Entendido',
                    style: _style(Colors.lightBlueAccent, 18),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ));
  }
}

class SliderTumbShape extends SliderComponentShape {
  final double height;
  final Color color;
  SliderTumbShape(this.height, this.color);
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(height, height);

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final Path path = Path();
    final RRect rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: height * 2.1, height: height * 1.1),
        Radius.circular(height));
    final RRect rRectbg = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: height * 2.1, height: height * 1.1),
        Radius.circular(height));
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final Paint paintPath = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final Paint paintbg = Paint()
      ..color = Color(0xFFF5F5F5)
      ..style = PaintingStyle.fill;
    path.moveTo(center.dx - height * 0.5 * 1.05, center.dy - (height * 0.55) + 8);
    path.lineTo(center.dx - height * 0.5 * 1.05, center.dy + (height * 0.55) - 8);
    path.moveTo(center.dx, center.dy - (height * 0.55) + 8);
    path.lineTo(center.dx, center.dy + (height * 0.55) - 8);
    path.moveTo(center.dx + height * 0.5 * 1.05, center.dy - (height * 0.55) + 8);
    path.lineTo(center.dx + height * 0.5 * 1.05, center.dy + (height * 0.55) - 8);
    canvas.drawRRect(rRectbg, paintbg);
    canvas.drawRRect(rRect, paint);
    canvas.drawPath(path, paintPath);
  }
}
