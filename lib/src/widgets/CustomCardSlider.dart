import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCardSlider extends StatefulWidget {
  final List<String> concentrations;
  final List<Color> colors;
  final ValueSetter<int> onChange;
  CustomCardSlider({
    Key key,
    this.concentrations,
    this.colors,
    @required this.onChange,
  }) : super(key: key);

  @override
  _CustomCardSliderState createState() => _CustomCardSliderState();
}

class _CustomCardSliderState extends State<CustomCardSlider> {
  Size screen;
  ValueNotifier<int> _indexNoti = ValueNotifier<int>(0);
  PageController _pageController = PageController(viewportFraction: 0.77);

  @override
  void initState() {
    widget.onChange(0);
    _pageController.addListener(() {
      _indexNoti.value = _pageController.page.round();
      if (_pageController.page == _pageController.page.floor())
        widget.onChange(_pageController.page.round());
    });
    super.initState();
  }

  @override
  void dispose() {
    _indexNoti.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    // ignore: non_constant_identifier_names
    List<Widget> _Dots = [];
    for (int i = 0; i < widget.concentrations.length; i++) {
      _Dots.add(_DotSlide(
        notifier: _indexNoti,
        index: i,
        colors: <Color>[_autoColor(widget.colors[0]), _autoColor(widget.colors[1])],
      ));
    }
    if (_indexNoti.value > widget.concentrations.length - 1) {
      _indexNoti.value = 0;
      widget.onChange(0);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.concentrations.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(right: 15),
              child: _CardSlider(
                index: index,
                concentration: widget.concentrations[index],
              ),
            ),
            controller: _pageController,
            physics: BouncingScrollPhysics(),
          ),
        ),
        SizedBox(
          height: screen.height * 0.025,
        ),
        Container(
          width: 300,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _Dots,
          ),
        ),
      ],
    );
  }

  Color _autoColor(Color color) {
    const List<double> proportions = [
      0.8470588235294118,
      1.154228855721393,
      0.6888888888888889
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
}

class _CardSlider extends StatefulWidget {
  final int index;
  final String concentration;
  _CardSlider({Key key, this.index, this.concentration}) : super(key: key);

  @override
  __CardSliderState createState() => __CardSliderState();
}

class __CardSliderState extends State<_CardSlider>
    with SingleTickerProviderStateMixin {
  Size screen;
  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    const double _height = 100;
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      width: screen.width < 450 ? screen.width - 80 : 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: _height * 0.50,
                  height: _height,
                  child:
                      Image.asset('res/img/ampolletas/a_${Random().nextInt(9)}.png'),
                ),
                Container(
                  width: _height * 0.50,
                  height: _height,
                  child: Image.asset('res/img/ampolleta_outline.png'),
                )
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Concentración ${widget.index + 1}',
                    style: GoogleFonts.montserrat(
                        fontSize: screen.width > 350 ? 18 : 14),
                  ),
                  Text(
                    widget.concentration,
                    style: GoogleFonts.montserrat(
                        fontSize: screen.width > 350 ? 18 : 16),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DotSlide extends StatefulWidget {
  final ValueNotifier<int> notifier;
  final List<Color> colors;
  final int index;
  _DotSlide({Key key, this.colors, this.index, @required this.notifier})
      : super(key: key);

  @override
  __DotSlideState createState() => __DotSlideState();
}

class __DotSlideState extends State<_DotSlide> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animationH;
  Animation<double> _animationO;
  Animation<Color> _animationColor;

  @override
  void initState() {
    _controller =
        new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationH = Tween<double>(begin: 8, end: 15)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.33)));
    _animationO = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.33, 0.66)));
    _animationColor = ColorTween(begin: widget.colors[1], end: widget.colors[0])
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.33, 1)));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (context, int value, child) {
        if (value == widget.index) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        return child;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: _animationH.value,
            width: _animationH.value,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: _animationColor.value),
            child: Opacity(
              opacity: _animationO.value,
              child: Center(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: _animationH.value,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
