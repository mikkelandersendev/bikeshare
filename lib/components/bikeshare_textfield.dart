import 'package:flutter/material.dart';

class BikeShareTextField extends StatelessWidget {
  var _inputText = "";
  TextEditingController _controller; 

  BikeShareTextField(this._inputText, TextEditingController this._controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _controller,
      style: TextStyle(color: Colors.white, fontSize: 18.0),
      decoration: InputDecoration(
        labelText: _inputText,
        fillColor: Colors.white.withOpacity(0.3),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}