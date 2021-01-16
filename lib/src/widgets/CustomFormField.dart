import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTextInputType { dosis, peso, nombre }

class CustomFormTextInput extends TextFormField {
  final CustomTextInputType textType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  CustomFormTextInput(
      {this.textType = CustomTextInputType.nombre,
      this.controller,
      this.textInputAction})
      : super(
            controller: controller,
            validator: (value) {
              if (textType == CustomTextInputType.peso) {
                if (value.isEmpty) {
                  return 'El campo no puede estar vacio';
                } else {
                  double _parse = double.parse(value);
                  if (_parse == -3000) {
                    return 'El valor no es un número';
                  } else if (_parse <= 0) {
                    return 'El valor no puede ser 0 o menor a 0';
                  } else
                    return null;
                }
              } else {
                if (value.isEmpty) {
                  return 'El campo no puede estar vacio';
                } else
                  return null;
              }
            },
            textInputAction: textInputAction,
            textCapitalization: textType == CustomTextInputType.nombre
                ? TextCapitalization.sentences
                : TextCapitalization.none,
            keyboardType: textType == CustomTextInputType.nombre
                ? TextInputType.name
                : TextInputType.numberWithOptions(decimal: true, signed: false),
            style: GoogleFonts.montserrat(),
            decoration: InputDecoration(
                errorStyle: GoogleFonts.montserrat(),
                labelText: textType == CustomTextInputType.nombre
                    ? 'Nombre'
                    : textType == CustomTextInputType.peso
                        ? 'Peso [Kg]'
                        : 'Dosis',
                labelStyle: GoogleFonts.montserrat(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )));
}
