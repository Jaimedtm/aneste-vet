import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/models/animal.dart';

class CustomAnimalChooser extends StatefulWidget {
  final ValueSetter<AnimalChooser> onChange;
  const CustomAnimalChooser({Key key, @required this.onChange}) : super(key: key);

  @override
  _CustomAnimalChooserState createState() => _CustomAnimalChooserState();
}

class _CustomAnimalChooserState extends State<CustomAnimalChooser> {
  ValueNotifier<bool> gatoNoti = ValueNotifier(false);
  ValueNotifier<bool> perroNoti = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ImgChooser(
                onPress: () {
                  perroNoti.value = !perroNoti.value;
                  gatoNoti.value = !perroNoti.value;
                  if (perroNoti.value)
                    widget.onChange(AnimalChooser.perro);
                  else
                    widget.onChange(AnimalChooser.gato);
                },
                valueNotifier: perroNoti,
                animal: AnimalChooser.perro,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ImgChooser(
                onPress: () {
                  gatoNoti.value = !gatoNoti.value;
                  perroNoti.value = !gatoNoti.value;
                  if (perroNoti.value)
                    widget.onChange(AnimalChooser.perro);
                  else
                    widget.onChange(AnimalChooser.gato);
                },
                valueNotifier: gatoNoti,
                animal: AnimalChooser.gato,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImgChooser extends StatefulWidget {
  final AnimalChooser animal;
  final ValueNotifier<bool> valueNotifier;
  final VoidCallback onPress;
  const ImgChooser(
      {Key key, @required this.animal, @required this.valueNotifier, this.onPress})
      : super(key: key);

  @override
  _ImgChooserState createState() => _ImgChooserState();
}

class _ImgChooserState extends State<ImgChooser>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Color> bgColor;
  Animation<Color> borderColor;
  Animation<Color> textColor;
  Size screen;

  @override
  void initState() {
    controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    bgColor = ColorTween(begin: Color(0xFFE2E2E2), end: Color(0x00FFFFFF))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 1.0)));
    borderColor = ColorTween(begin: Color(0x00FFFFFF), end: Color(0xFF724BB4))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.25, 1.0)));
    textColor = ColorTween(begin: Color(0xFF747474), end: Color(0xFF724BB4))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.25, 1.0)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onPress,
      child: ValueListenableBuilder(
          valueListenable: widget.valueNotifier,
          builder: (context, bool value, child) {
            if (value && controller.status == AnimationStatus.dismissed) {
              controller.forward();
            } else if (!value && controller.status == AnimationStatus.completed) {
              controller.reverse();
            }
            return AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Container(
                    constraints: BoxConstraints(
                      maxWidth: 170 * 0.925,
                      maxHeight: 170,
                    ),
                    height: screen.width > 355
                        ? screen.height * 0.30
                        : screen.height * 0.26,
                    width: screen.width > 355
                        ? screen.height * 0.30 * 0.925
                        : screen.height * 0.26 * 0.925,
                    decoration: BoxDecoration(
                      color: bgColor.value,
                      border: Border.all(color: borderColor.value, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screen.height * 0.30 * 0.925 * 0.07),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            widget.animal == AnimalChooser.gato
                                ? 'res/img/cat_chose.png'
                                : 'res/img/dog_chose.png',
                          ),
                          Text(
                            widget.animal == AnimalChooser.gato ? 'Gato' : 'Perro',
                            style: GoogleFonts.roboto(
                                color: textColor.value,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ));
              },
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    widget.valueNotifier.dispose();
    super.dispose();
  }
}

class GenderChoser extends StatefulWidget {
  final ValueSetter<GenderChose> onChange;
  GenderChoser({Key key, this.onChange}) : super(key: key);

  @override
  _GenderChoserState createState() => _GenderChoserState();
}

class _GenderChoserState extends State<GenderChoser> {
  ValueNotifier<bool> machoNoti = ValueNotifier(false);
  ValueNotifier<bool> hembraNoti = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _GenderChoser(
                onPress: () {
                  machoNoti.value = !machoNoti.value;
                  hembraNoti.value = !machoNoti.value;
                  if (machoNoti.value)
                    widget.onChange(GenderChose.macho);
                  else
                    widget.onChange(GenderChose.hembra);
                },
                valueNotifier: hembraNoti,
                genero: GenderChose.hembra,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _GenderChoser(
                onPress: () {
                  hembraNoti.value = !hembraNoti.value;
                  machoNoti.value = !hembraNoti.value;
                  if (machoNoti.value)
                    widget.onChange(GenderChose.macho);
                  else
                    widget.onChange(GenderChose.hembra);
                },
                valueNotifier: machoNoti,
                genero: GenderChose.macho,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderChoser extends StatefulWidget {
  final GenderChose genero;
  final ValueNotifier<bool> valueNotifier;
  final VoidCallback onPress;
  _GenderChoser(
      {Key key, @required this.genero, @required this.valueNotifier, this.onPress})
      : super(key: key);

  @override
  __GenderChoserState createState() => __GenderChoserState();
}

class __GenderChoserState extends State<_GenderChoser>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Color> bgColor1;
  Animation<Color> bgColor2;
  Animation<Color> borderColor;
  Animation<Color> textColor;
  Size screen;

  void initState() {
    controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    bgColor1 = ColorTween(
            end: widget.genero == GenderChose.hembra
                ? Color(0xFFF95089)
                : Color(0xFF2D8BE6),
            begin: Color(0x00FFFFFF))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.25, 1.0)));
    bgColor2 = ColorTween(
            end: widget.genero == GenderChose.hembra
                ? Color(0xFFF39A9A)
                : Color(0xFF66E8FF),
            begin: Color(0x00FFFFFF))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.25)));
    borderColor = ColorTween(
            begin: widget.genero == GenderChose.hembra
                ? Color(0xFFF95089)
                : Color(0xFF2D8BE6),
            end: Color(0x00FFFFFF))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.0, .50)));
    textColor = ColorTween(
            begin: widget.genero == GenderChose.hembra
                ? Color(0xFFF95089)
                : Color(0xFF2D8BE6),
            end: Color(0xFFFFFFFF))
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.5, 1.0)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onPress,
      child: ValueListenableBuilder(
        valueListenable: widget.valueNotifier,
        builder: (context, bool value, child) {
          if (value && controller.status == AnimationStatus.dismissed) {
            controller.forward();
          } else if (!value && controller.status == AnimationStatus.completed) {
            controller.reverse();
          }
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return Container(
                  constraints: BoxConstraints(
                    maxWidth: 185,
                    maxHeight: 64,
                  ),
                  height: screen.height * 0.20 * 2.89,
                  width: screen.height * 0.20,
                  decoration: BoxDecoration(
                    color: bgColor1.value,
                    gradient:
                        LinearGradient(colors: [bgColor1.value, bgColor2.value]),
                    border: Border.all(color: borderColor.value, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                    widget.genero == GenderChose.hembra ? 'Hembra' : 'Macho',
                    style:
                        GoogleFonts.montserrat(color: textColor.value, fontSize: 22),
                  )));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    widget.valueNotifier.dispose();
    super.dispose();
  }
}
