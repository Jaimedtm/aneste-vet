import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/models/Summary.dart';
import 'package:vetcalc/src/medicamentos/Fluidoterapia.dart';
import 'package:vetcalc/src/pages/SummaryPage.dart';
import 'package:vetcalc/src/widgets/CustomHeader.dart';
import 'package:vetcalc/src/widgets/SlidePageRoute.dart';

typedef SelectionValue = void Function();

class FluidoPage extends StatefulWidget {
  final SelectionValue callback;
  final bool toEdit;
  const FluidoPage({Key key, this.callback, this.toEdit = false}) : super(key: key);

  @override
  _FluidoPageState createState() => _FluidoPageState();
}

class _FluidoPageState extends State<FluidoPage> {
  bool _normogotero = true;
  List<double> _perdida = [];
  List<Key> _keys = [];
  Size screen;
  ScrollController _controller = ScrollController();
  ValueNotifier<double> _notifierSlider = ValueNotifier(5);

  @override
  void dispose() {
    _notifierSlider.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screen.height * 0.14,
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: _notifierSlider,
                      builder: (context, value, child) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Column(
                              children: [
                                Text(
                                  'Porcentaje de deshidratación:\n${_notifierSlider.value}%',
                                  style: GoogleFonts.montserrat(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                _slider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Min: 5%',
                                        style: GoogleFonts.montserrat(),
                                      ),
                                      Text(
                                        'Max: 12%',
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
                      },
                    ),
                    _perdida.length > 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _perdidaSensible(),
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: screen.width,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          color: _perdida.length == 1
                              ? Colors.grey[350]
                              : Color(0xFF1BC980),
                          child: Text(
                            'Añadir perdidas sensibles.',
                            style: _style(Colors.white),
                          ),
                          onPressed: _perdida.length == 1
                              ? () {}
                              : () {
                                  setState(() {
                                    _keys.add(UniqueKey());
                                    _perdida.add(0);
                                    /* if (_perdida.length >= 2) {
                                double _off = _controller.position.maxScrollExtent -
                                    _controller.offset +
                                    80;
                                _controller.animateTo(_controller.offset + _off,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linear);
                              } */
                                  });
                                },
                        )),
                    SizedBox(height: screen.height > 568 ? 50 : 10),
                    Container(
                      width: screen.width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      child: Card(
                        child: Column(
                          children: [
                            Text(
                              '¿Qué gotero deseas usar?',
                              style: _style(null, 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Normogotero',
                                  style: _style(null, screen.width > 350 ? 16 : 12),
                                ),
                                Checkbox(
                                    activeColor: Color(0xFF99C542),
                                    value: _normogotero,
                                    onChanged: (value) {
                                      setState(() {
                                        _normogotero = value;
                                      });
                                    }),
                                Text(
                                  'Microgotero',
                                  style: _style(null, screen.width > 350 ? 16 : 12),
                                ),
                                Checkbox(
                                    activeColor: Color(0xFF99C542),
                                    value: !_normogotero,
                                    onChanged: (value) {
                                      _normogotero = !_normogotero;
                                      setState(() {});
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          CurveHeader(
            title: 'Fluidoterapia',
            colors: [Color(0xFF99C542), Color(0xFF1BC980)],
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

  Widget _ajusteFino() {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFF99C542)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Ajuste fino: 0.01%',
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
                          color:
                              _notifierSlider.value > 5 ? Colors.red : Colors.grey,
                        ),
                        Container(
                          height: 30,
                          child: OutlineButton(
                              borderSide: BorderSide(width: 2, color: Colors.red),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              onPressed: _notifierSlider.value > 5
                                  ? () {
                                      _notifierSlider.value -= 0.011;
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
                          color: _notifierSlider.value < 12
                              ? Color(0xFF1BC980)
                              : Colors.grey,
                        ),
                        Container(
                          height: 30,
                          child: OutlineButton(
                              borderSide:
                                  BorderSide(width: 2, color: Color(0xFF1BC980)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              onPressed: _notifierSlider.value < 12
                                  ? () {
                                      _notifierSlider.value += 0.01;
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

  Widget _buttons() {
    bool _disableButton = false;
    Function _finalize = () {
      _addToSummary();
      Navigator.of(context).push(SlidePageRoute(SummaryPage()));
    };

    if (_perdida.length > 0) {
      _perdida.forEach((value) {
        _disableButton = value <= 0;
      });
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
                  color: Color(0xFF1BC980),
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
                  color: Color(0xFF99C542),
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
                  color: Color(0xFF1BC980),
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
                  color: Color(0xFF99C542),
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

  Widget _slider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 55,
      width: screen.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
            activeTrackColor: Color(0xFF1BC980),
            inactiveTrackColor: Color(0xFF1BC980).withOpacity(0.5),
            inactiveTickMarkColor: Colors.white38,
            thumbShape: SliderTumbShape(25, Color(0xFF99C542)),
            overlayColor: Colors.transparent,
            trackHeight: 7),
        child: Slider(
          value: _notifierSlider.value,
          label: '${_notifierSlider.value}%',
          divisions: 1100,
          min: 5,
          max: 12,
          onChanged: (value) {
            _notifierSlider.value = double.parse(value.toStringAsFixed(2));
          },
        ),
      ),
    );
  }

  Widget _perdidaSensible() {
    return Theme(
      data: ThemeData(accentColor: Color(0xFF99C542), primaryColor: Colors.green),
      child: Container(
        constraints: BoxConstraints(maxHeight: 200, minWidth: screen.width),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              heightFactor: 1,
              child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: _perdida.length,
                  physics: _perdida.length > 2
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: _keys[index],
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          _keys.removeAt(index);
                          _perdida.removeAt(index);
                        });
                      },
                      child: Container(
                        height: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value != '') {
                              setState(() {
                                _perdida[index] = double.parse(value);
                              });
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelStyle: _style(Colors.grey),
                              errorStyle: _style(Colors.redAccent, 14),
                              labelText: 'Cantidad en ml',
                              errorText: _perdida[index] <= 0
                                  ? 'El valor no debe ser 0'
                                  : null),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _style([Color color, double fontSize]) {
    color ??= color = Colors.black;
    fontSize ??= screen.width > 350 ? 17 : 15;
    return GoogleFonts.montserrat(fontSize: fontSize, color: color);
  }

  void _addToSummary() {
    if (widget.toEdit) Summary().fluidoterapia = null;
    Summary().fluidoterapia = new Fluidoterapia(
        _normogotero ? Gotero.Normogotero : Gotero.Microgotero,
        _notifierSlider.value,
        _perdida.length > 0 ? _perdida : null);
    Summary().selections.add(Selections.fluidtherapy);
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
