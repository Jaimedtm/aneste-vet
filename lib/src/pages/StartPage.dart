import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/models/Summary.dart';
import 'package:vetcalc/src/widgets/CustomFormField.dart';
import 'package:vetcalc/src/pages/SelectionPage.dart';
import 'package:vetcalc/src/widgets/CustomChooser.dart';
import 'package:vetcalc/src/widgets/CustomHeader.dart';
import 'package:vetcalc/src/models/animal.dart';
import 'package:vetcalc/src/widgets/SlidePageRoute.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Animal _animal = Dog(gender: GenderChose.hembra);
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerWeight = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: screen.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 2,
                child: CurveHeader(
                  onPress: () => Summary().reset(),
                  title: 'Datos de la mascota',
                ),
              ),
              Flexible(
                flex: 3,
                child: CustomAnimalChooser(
                  onChange: (value) {
                    if (value == AnimalChooser.perro) {
                      _animal = Dog();
                    } else {
                      _animal = Cat();
                    }
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  height: screen.height * 0.3,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomFormTextInput(
                            textType: CustomTextInputType.nombre,
                            controller: _controllerName,
                          ),
                          CustomFormTextInput(
                            textType: CustomTextInputType.peso,
                            controller: _controllerWeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GenderChoser(
                  onChange: (value) {
                    _animal.gender = value;
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 64, maxWidth: 400),
                  height: 64,
                  width: screen.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(bottom: 20),
                  child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _animal.name = _controllerName.text;
                        _animal.weight = double.parse(_controllerWeight.text);
                        Summary().animal = _animal;
                        Navigator.of(context).push(SlidePageRoute(SelectionPage()));
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF724BB4), Color(0xFFE47AE8)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(80.0)),
                      child: Center(
                          child: Text(
                        'Continuar',
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 22),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
