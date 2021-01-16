import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/pages/StartPage.dart';
import 'package:vetcalc/src/widgets/SlidePageRoute.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    if (screen.width > 500) {
      return Scaffold(
        body: Center(
          child: Text(
            'Esta PWA solo fue diseñada para smartphones',
            style: GoogleFonts.montserrat(fontSize: 20),
          ),
        ),
      );
    } else
      return Scaffold(
        body: Container(
          height: screen.height,
          width: screen.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: screen.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.info,
                          size: 30,
                          color: Colors.blue[300],
                        ),
                        onPressed: () => _aboutUs(context, screen)),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      'Información sobre Aneste-Vet',
                      style: GoogleFonts.montserrat(fontSize: 17),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                    height: screen.width * 0.2,
                    child: Image.asset('res/vetCalc.png'),
                  )),
              Flexible(
                flex: 4,
                child: Container(
                  height: screen.width * 0.75,
                  child: Image.asset('res/img/intro.png'),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  height: 70,
                  width: screen.width,
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70)),
                    textColor: Colors.white,
                    child: Text(
                      'Comenzar',
                      style: GoogleFonts.montserrat(fontSize: 20),
                    ),
                    color: Color(0xFF74B1D3),
                    onPressed: () =>
                        Navigator.of(context).push(SlidePageRoute(StartPage())),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  void _aboutUs(context, Size screen) {
    showAboutDialog(
        context: context,
        children: [
          RichText(
            text: TextSpan(
              text: 'https://stories.freepik.com/animal',
              style: TextStyle(decoration: TextDecoration.underline),
              //TODO: abrir enlace
            ),
          ),
        ],
        applicationName: 'Aneste-Vet',
        applicationVersion: '1.1',
        applicationLegalese: 'Illustraciones por Freepik Stories, enlace:',
        applicationIcon: Container(
          height: screen.height * 0.05,
          child: Image.asset('res/favicon_512.png'),
        ));
  }
}
