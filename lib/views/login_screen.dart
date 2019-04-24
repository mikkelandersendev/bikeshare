import 'package:flutter/material.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/views/list_of_bikes.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: "hero",
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset("assets/images/bikeshare.png")
          ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.white, fontSize: 18.0),
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.3),
        filled: true,
        labelText: "Email",
        hintText: "Email",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      style: TextStyle(color: Colors.white, fontSize: 18.0),
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.3),
        labelText: "Password",
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

    final loginButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BikeList()));
          print("logged in");
        },
        child: Text(
          "LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: HexColor("#3a4256"), fontSize: 18.0, letterSpacing: 2.0),
        ),
      ),
    );

final bikeShareBackground = Stack(
  children: <Widget>[
    Container(
      padding: EdgeInsets.only(left: 10.0),
        height: 200,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/trees.jpg"),
            fit: BoxFit.cover,
          ),
        ),
    ),

    // Blue filter overlay (transparent overlay)
    Container(
      height: 200,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .7)),
          child: Center(
            child: Text("Mock bike", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          ),
    ),
  ],
);

    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage("assets/images/concretebike.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 60.0, right: 60.0),
            children: <Widget>[
              logo,
              SizedBox(
                height: 80.0,
              ),
              email,
              SizedBox(
                height: 8.0,
              ),
              password,
              SizedBox(
                height: 24.0,
              ),
              loginButton,
            ],
          ),
        ),
      ),
    );
  }
}
