import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> listToItem(List<String> list) {
  return list.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}

List<String> getImgPath(String dir, String name, int number) {
  List<String> _l = [];
  for (int i = 0; i <= number - 1; i++) {
    _l.add('res/medicamentos/$dir/$name/img_$i.png');
  }
  return _l;
}

double getmGMl(String value, bool isMg) {
  int _slash = value.lastIndexOf('/');
  double _r;
  if (isMg) {
    _r = double.parse(value.substring(0, _slash - 2));
  } else {
    if (value.substring(_slash + 1, value.length - 2) == "")
      _r = 1;
    else
      _r = double.parse(value.substring(_slash + 1, value.length - 2));
  }
  return _r;
}

String mgOrmcg(double value) {
  String _help = (value * 1000).toString();
  if (value < 0.01) {
    if (_help.length > 5)
      _help = _help.substring(0, 3);
    else
      _help = _help;
    return '${_help.toString()}µg/kg';
  } else
    return '${value.toString()}mg/kg';
}

double fixValues(double value, bool x) {
  int _p = value > 10 ? 3 : 4;
  if (x) _p = 2;
  String _s = (value * 0.001).toStringAsFixed(_p);
  return double.parse(_s);
}

double fixValue(double value) {
  String s = value.toString();
  if (value > 0.999) {
    s = value.toStringAsFixed(2);
  } else if (value > 0.099) {
    s = value.toStringAsFixed(3);
  } else if (value > 0.009) {
    s = value.toStringAsFixed(4);
  } else if (value > 0.0009) {
    s = value.toStringAsFixed(5);
  }
  return double.parse(s);
}
