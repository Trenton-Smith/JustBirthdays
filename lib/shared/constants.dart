import 'package:flutter/material.dart';


//hypothetical styling of input fields - currently not implemented
const textInputDecoration = InputDecoration(
  // hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
  ),
);