import 'package:vetcalc/src/models/animal.dart';
import 'package:vetcalc/src/medicamentos/Fluidoterapia.dart';
import 'package:vetcalc/src/util/globalMethods.dart';

enum Selections { opioid, inductor, premedication, analgesic, fluidtherapy }

class Summary {
  Animal animal;
  List<Selections> selections = [];
  List<InformerDrug> inform = [];
  Fluidoterapia fluidoterapia;
  static Summary _instance = Summary._internal();
  factory Summary() {
    return _instance;
  }
  Summary._internal();

  void reset() {
    selections = [];
    inform = [];
    animal = null;
    fluidoterapia = null;
  }

  String get animalString => animal is Dog ? 'perro' : 'gato';
  String get animalGenero => animal.gender == GenderChose.macho ? 'Macho' : 'Hembra';

  bool isCompleted() {
    bool result = selections.length >= 4;
    return result;
  }

  void deleteSelection(Selections s) {
    selections.remove(s);
    inform.removeWhere((drug) => drug.type == s);
  }

  @override
  String toString() {
    return 'Resumen:\n${animal.toString()}\n $selections';
  }
}

class InformerDrug {
  double _dose;
  String name;
  String concentration;
  Selections type;
  InformerDrug(this.name, this.concentration, this.type, double dose) {
    _dose = dose;
  }
  double get dose {
    return _dose / 1000;
  }

  double get concentrationMg {
    int index = concentration.indexOf('/');
    return double.parse(concentration.substring(0, index - 2));
  }

  double get concentrationMl {
    int index = concentration.indexOf('/');

    if (concentration.substring(index + 1) == 'ml') {
      return 1;
    } else {
      return double.parse(
          concentration.substring(index + 1, concentration.length - 2));
    }
  }

  double get mgTotales {
    double resp = Summary().animal.weight * this.dose;
    resp = _fixValue(resp);
    return resp;
  }

  double get dosisTotalML {
    double resp = (this.mgTotales * this.concentrationMl) / this.concentrationMg;
    resp = _fixValue(resp);
    return resp;
  }

  double _fixValue(double value) {
    String resp = value.toString();
    final int index = resp.indexOf('.') + 1;
    final int decimas = resp.substring(index).length;
    if (decimas > 4) {
      resp = resp.substring(0, index + 5);
    }
    return double.parse(resp);
  }

  String get doseString => mgOrmcg(_fixValue(this.dose));
}
