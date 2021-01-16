import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class _PremedProvider {
  Future<Map<String, dynamic>> getData() async {
    String _s = await rootBundle.loadString('res/premedicacion.json');
    Map<String, dynamic> dataMap = json.decode(_s);
    return dataMap;
  }
}

class _OpiodesProvider {
  Future<Map<String, dynamic>> getData() async {
    String _s = await rootBundle.loadString('res/opioides.json');
    Map<String, dynamic> dataMap = json.decode(_s);
    return dataMap;
  }
}

class _InductoresProvider {
  Future<Map<String, dynamic>> getData() async {
    String _s = await rootBundle.loadString('res/inductores.json');
    Map<String, dynamic> dataMap = json.decode(_s);
    return dataMap;
  }
}

class _AnalgesicosProvider {
  Future<Map<String, dynamic>> getData() async {
    String _s = await rootBundle.loadString('res/analgesia.json');
    Map<String, dynamic> dataMap = json.decode(_s);
    return dataMap;
  }
}

final _PremedProvider premedProvider = _PremedProvider();
final _OpiodesProvider opiodesProvider = _OpiodesProvider();
final _InductoresProvider inductoresProvider = _InductoresProvider();
final _AnalgesicosProvider analgesicosProvider = _AnalgesicosProvider();
