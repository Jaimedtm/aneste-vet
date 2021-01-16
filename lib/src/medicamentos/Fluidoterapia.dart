import 'package:vetcalc/src/models/Summary.dart';

enum Gotero { Normogotero, Microgotero }

class Fluidoterapia {
  List<double> _perdidaList = [];
  double _peso;
  double porcentajeDeshidratacion;
  double _mlMtto;
  String _animal;
  Gotero gotero;

  Fluidoterapia(this.gotero, this.porcentajeDeshidratacion, [List<double> perdida]) {
    _perdidaList = perdida ?? [];
    _animal = Summary().animalString;
    _peso = Summary().animal.weight;
  }

  String get goteroString =>
      gotero == Gotero.Normogotero ? 'Normogotero' : 'Microgotero';

  double get mlMantenimiento {
    if (_animal == 'gato' || (_animal == 'perro' && _peso <= 12)) {
      _mlMtto = 60 * _peso;
    } else {
      _mlMtto = 50 * _peso;
    }
    return _fixValue(_mlMtto);
  }

  double get mlAdministrar {
    return _fixValue(porcentajeDeshidratacion * _peso * 10);
  }

  double get mlTotales24hrs {
    double result = this.mlMantenimiento + this.mlAdministrar;
    if (_perdidaList.length > 0) {
      _perdidaList.forEach((value) {
        result += value;
      });
    }
    return result;
  }

  double get perdidaSensible {
    double perdida = 0;
    _perdidaList.forEach((element) {
      perdida += element;
    });
    return perdida;
  }

  int get gotasHora {
    num resp = this.mlTotales24hrs * (gotero == Gotero.Normogotero ? 20 : 60);
    resp /= 24;
    resp = resp.round();
    return resp as int;
  }

  double _fixValue(double value) {
    String resp = value.toString();
    final int index = resp.indexOf('.') + 1;
    final int decimas = resp.substring(index).length;
    if (decimas > 3) {
      resp = resp.substring(0, index + 3);
    }
    return double.parse(resp);
  }
}
