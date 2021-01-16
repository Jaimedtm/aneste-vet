import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetcalc/src/util/globalMethods.dart';

class CustomDropDown extends DropdownButton {
  CustomDropDown(
      {String value,
      Color color,
      List<String> items,
      ValueSetter<String> onChanged,
      Size screen})
      : super(
          value: value,
          hint: Text('Seleccione un farmaco'),
          iconEnabledColor: color,
          style: GoogleFonts.montserrat(
              fontSize: screen.width < 350 ? 16 : 20, color: Colors.black),
          underline: Container(
            height: 3,
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
          ),
          items: listToItem(items),
          onChanged: (v) {
            onChanged(v);
          },
        );
}
