import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/login_screen.dart';

void main() => runApp(BikeShareApp());

class BikeShareApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BikeShareState();
  }
}

class BikeShareState extends State<BikeShareApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: LoginPage()
        );
  }
}