import 'package:vetcalc/src/util/fromJSON.dart';

class CalculoAnestesico {
  double peso = 0;
  String animal = 'perro';
}

abstract class DrugModel {
  init([String name]);
  List<String> get productos;
  List<String> get concentraciones;
  int get cantidad;
  double get dosisMin;
  double get dosisMax;
}

class Premedicacion extends DrugModel {
  int _cantidadProductos;
  String _name;
  String _dosisMin;
  String _dosisMax;
  List<String> _productos = [];
  List<String> _concentracion = [];
  Map<String, dynamic> _dataMap;

  Premedicacion([String name]) {
    this._name = name;
  }

  init([String n]) async {
    if (n == null) {
      n = _name;
    } else {
      _name = n;
    }
    _dataMap = await premedProvider.getData();
    List _l = _dataMap[_name];
    Map _temp = _l[0];
    _dosisMin = _temp['dosis minima'];
    _dosisMax = _temp['dosis maxima'];
    List _l2 = _temp['producto comercial'];
    _cantidadProductos = _l2.length;
    for (Map m in _l2) {
      _productos.add(m['nombre']);
      _concentracion.add(m['concentracion']);
    }
  }

  List<String> get productos {
    return _productos;
  }

  List<String> get concentraciones {
    return _concentracion;
  }

  int get cantidad {
    return _cantidadProductos;
  }

  double get dosisMax {
    return double.parse(_dosisMax);
  }

  double get dosisMin {
    return double.parse(_dosisMin);
  }
}

class FarmacoInductor extends DrugModel {
  int _cant;
  bool _premed = false;
  String _name;
  String _maxPerro;
  String _minPerro;
  String _maxGato;
  String _minGato;
  String _animal;
  List<String> _productos = [];
  List<String> _concentraciones = [];
  Map<String, dynamic> _dataMap;

  FarmacoInductor(String animal, [bool premed, String name]) {
    this._premed = premed;
    this._name = name;
    this._animal = animal;
  }

  init([String n]) async {
    if (n == null) {
      n = _name;
    } else {
      _name = n;
    }
    _dataMap = await inductoresProvider.getData();
    List _l = _dataMap[_name];
    Map _temp = _l[0];
    List _lC = _premed ? _temp['con premedicación'] : _temp['sin premedicación'];
    Map _temp2 = _lC[0];
    _maxPerro = _temp2['dosis maxima perro'];
    _minPerro = _temp2['dosis minima perro'];
    _maxGato = _temp2['dosis maxima gato'];
    _minGato = _temp2['dosis minima gato'];
    List _l2 = _temp['producto comercial'];
    _cant = _l2.length;
    for (Map m in _l2) {
      _productos.add(m['nombre']);
      _concentraciones.add(m['concentracion']);
    }
  }

  List<String> get productos {
    return _productos;
  }

  List<String> get concentraciones {
    return _concentraciones;
  }

  int get cantidad {
    return _cant;
  }

  double get dosisMin {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_minPerro);
    else
      _hlp = double.parse(_minGato);

    return _hlp;
  }

  double get dosisMax {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_maxPerro);
    else
      _hlp = double.parse(_maxGato);

    return _hlp;
  }
}

class Opioide extends DrugModel {
  int _cant;
  String _name;
  String _maxPerro;
  String _minPerro;
  String _maxGato;
  String _minGato;
  String _animal;
  List<String> _productos = [];
  List<String> _concentraciones = [];
  Map<String, dynamic> _dataMap;

  Opioide(String animal, [String name]) {
    this._name = name;
    this._animal = animal;
  }

  init([String n]) async {
    if (n == null) {
      n = _name;
    } else {
      _name = n;
    }
    _dataMap = await opiodesProvider.getData();
    List _l = _dataMap[_name];
    Map _temp = _l[0];
    _maxPerro = _temp['dosis maxima perro'];
    _minPerro = _temp['dosis minima perro'];
    _maxGato = _temp['dosis maxima gato'];
    _minGato = _temp['dosis minima gato'];
    List _l2 = _temp['producto comercial'];
    _cant = _l2.length;
    for (Map m in _l2) {
      _productos.add(m['nombre']);
      _concentraciones.add(m['concentracion']);
    }
  }

  List<String> get productos {
    return _productos;
  }

  List<String> get concentraciones {
    return _concentraciones;
  }

  int get cantidad {
    return _cant;
  }

  double get dosisMin {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_minPerro);
    else
      _hlp = double.parse(_minGato);

    return _hlp;
  }

  double get dosisMax {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_maxPerro);
    else
      _hlp = double.parse(_maxGato);

    return _hlp;
  }
}

class Analgesia extends DrugModel {
  int _cant;
  String _name;
  String _maxPerro;
  String _minPerro;
  String _maxGato;
  String _minGato;
  String _animal;
  List<String> _productos = [];
  List<String> _concentraciones = [];
  Map<String, dynamic> _dataMap;

  Analgesia(String animal, [String name]) {
    this._name = name;
    this._animal = animal;
  }

  init([String n]) async {
    if (n == null) {
      n = _name;
    } else {
      _name = n;
    }
    _dataMap = await analgesicosProvider.getData();
    List _l = _dataMap[_name];
    Map _temp = _l[0];
    _maxPerro = _temp['dosis maxima perro'];
    _minPerro = _temp['dosis minima perro'];
    _maxGato = _temp['dosis maxima gato'];
    _minGato = _temp['dosis minima gato'];
    List _l2 = _temp['producto comercial'];
    _cant = _l2.length;
    for (Map m in _l2) {
      _productos.add(m['nombre']);
      _concentraciones.add(m['concentracion']);
    }
  }

  List<String> get productos {
    return _productos;
  }

  List<String> get concentraciones {
    return _concentraciones;
  }

  int get cantidad {
    return _cant;
  }

  double get dosisMin {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_minPerro);
    else
      _hlp = double.parse(_minGato);

    return _hlp;
  }

  double get dosisMax {
    double _hlp = 0;
    if (_animal == 'perro')
      _hlp = double.parse(_maxPerro);
    else
      _hlp = double.parse(_maxGato);

    return _hlp;
  }
}
