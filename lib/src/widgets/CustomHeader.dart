import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(),
            height: double.infinity,
            width: double.infinity,
            child: CustomPaint(
              painter: _HeaderPaint(),
            ),
          ),
          Container(
            height: screen.height * 0.15,
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: screen.height * 0.15,
            width: screen.width * 0.2,
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 20),
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () {
                //Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: Offset(0, size.height * 0.08), radius: 45);
    final Paint paint = Paint();
    final Gradient gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[Color(0xFF724BB4), Color(0xFFE47AE8)]);
    final Path path = Path();
    paint.style = PaintingStyle.fill;
    paint.shader = gradient.createShader(rect);

    path.lineTo(0, size.height * 0.09);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.18, size.width, size.height * 0.09);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurveHeader extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final Function onPress;
  const CurveHeader({Key key, this.title, this.colors, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            height: screen.height * 0.16,
            width: double.infinity,
            child: CustomPaint(
              painter: _CurveHeaderPaint(colors: colors),
            ),
          ),
          Container(
            width: double.infinity,
            height: screen.height * 0.13,
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              width: screen.width * 0.13,
              height: screen.height * 0.13,
              alignment: Alignment.center,
              child: IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (onPress != null) onPress();
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }
}

class CurveHeaderSummary extends StatelessWidget {
  final Function onPress;
  const CurveHeaderSummary({Key key, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            height: screen.height * 0.16,
            width: double.infinity,
            child: CustomPaint(
              painter:
                  _CurveHeaderPaint(colors: [Color(0xFFBFE613), Color(0xFF57C9A3)]),
            ),
          ),
          Container(
            width: double.infinity,
            height: screen.height * 0.13,
            alignment: Alignment.center,
            child: Text(
              'Resumen',
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              width: screen.width * 0.13,
              height: screen.height * 0.13,
              alignment: Alignment.center,
              child: IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (onPress != null)
                    onPress();
                  else
                    Navigator.of(context).pop();
                },
              ))
        ],
      ),
    );
  }
}

class _CurveHeaderPaint extends CustomPainter {
  List<Color> colors;
  _CurveHeaderPaint({this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    colors ??= [Color(0xFF724BB4), Color(0xFFE47AE8)];
    final Rect rect =
        Rect.fromCircle(center: Offset(0, size.height * 0.4), radius: 35);
    final Paint paint = Paint();
    final Gradient gradient = LinearGradient(
        begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: colors);
    final Path path = Path();
    paint.style = PaintingStyle.fill;
    paint.shader = gradient.createShader(rect);

    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 1.3, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
