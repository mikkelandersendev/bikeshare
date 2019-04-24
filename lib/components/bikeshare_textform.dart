import 'package:flutter/material.dart';

class BikeShareTextForm extends StatelessWidget {
  var _inputLabel = "";

  BikeShareTextForm(this._inputLabel);

  
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          padding: EdgeInsets.all(30.0),
          color: Colors.white,
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: _inputLabel,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.green // may remove this
                        )
                      )
                    ),
                    validator: (value) {
                      if(value.length == 0) 
                      {
                        return "Value cannot be empty";
                      } else 
                      {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

}