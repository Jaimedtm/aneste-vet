import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomImageButton extends StatefulWidget {
  final List<Color> colors;
  final String title;
  final String imgPath;
  final Function onPress;
  CustomImageButton(
      {Key key, this.colors, @required this.imgPath, this.title, this.onPress})
      : super(key: key);

  @override
  _CustomImageButtonState createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton>
    with SingleTickerProviderStateMixin {
  Size screen;
  AnimationController controller;
  Animation<Color> color1, color2;

  @override
  void initState() {
    controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    color1 = new ColorTween(begin: widget.colors[0], end: widget.colors[1])
        .animate(CurvedAnimation(parent: controller, curve: Interval(0, .5)));
    color2 = new ColorTween(begin: widget.colors[1], end: widget.colors[0])
        .animate(CurvedAnimation(parent: controller, curve: Interval(0.5, 1)));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTapDown: (details) => controller.forward(),
      onTapCancel: () => controller.reverse(),
      onTapUp: (details) {
        controller.reverse().then((value) => widget.onPress());
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 150,
            maxWidth: screen.width > 350 ? 400 : 340,
            minHeight: 130,
            minWidth: 330),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            clipBehavior: Clip.antiAlias,
            //color: Colors.red,
            child: Stack(
              children: [
                Image.asset(widget.imgPath),
                Container(
                  width: screen.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0x00FFFFFF),
                          widget.colors == null ? Colors.yellow : color1.value,
                          widget.colors == null ? Colors.greenAccent : color2.value,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: <double>[.0, 0.55, 1]),
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: screen.width * 0.10),
                  child: Text(
                    widget.title ?? 'Title',
                    style: GoogleFonts.montserrat(
                        color: _autoColor(widget.colors[0] ??= Colors.yellow),
                        fontSize: screen.width > 350 ? 23 : 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _autoColor(Color color) {
    const List<double> proportions = [
      0.5311203319502075,
      0.48186528497409326,
      0.7777777777777778
    ];
    List<int> colorRGB = _colorHexToInt(color);
    List<int> _newColor = [1, 1, 1];
    List<int> sortedColor = [];
    colorRGB.forEach((elem) => sortedColor.add(elem));
    sortedColor.sort((a, b) => -a.compareTo(b));
    //Repuesta
    for (int i = 0; i < sortedColor.length; i++) {
      _newColor[colorRGB.indexOf(sortedColor[i])] =
          (colorRGB[colorRGB.indexOf(sortedColor[i])] * proportions[i]).floor();
    }

    return Color.fromRGBO(_newColor[0], _newColor[1], _newColor[2], 1);
  }

  List<int> _colorHexToInt(Color color) {
    String _color = color.toString();
    _color = _color.substring(10, _color.length - 1);
    List<int> colorRGB = [];
    for (int i = 0; i < _color.length - 3; i++) {
      if (i == 0) {
        colorRGB.add(int.parse('0x' + _color.substring(i, i + 2)));
      } else {
        colorRGB.add(int.parse('0x' +
            _color.substring(i == 2 ? i + 2 : i + 1, i == 2 ? i + 4 : i + 3)));
      }
    }

    return colorRGB;
  }

  // List<double> rgbProportions(List<int> color1, List<int> color2) {
  //   List<double> proportion = [];
  //   for (int i = 0; i < color1.length; i++) {
  //     proportion.add(color2[i] / color1[i]);
  //   }
  //   return proportion;
  // }
}
