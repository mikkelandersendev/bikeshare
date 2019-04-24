import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/login_screen.dart';
import 'package:bikeshareapp/views/map.dart';
import 'package:bikeshareapp/views/list_of_bikes.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/views/rides_history.dart';
import 'package:bikeshareapp/views/payment_history.dart';
import 'package:bikeshareapp/views/credits.dart';

class BurgerContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BurgerContentState();
  }
}

class BurgerContentState extends State<BurgerContent> {

  Widget horizontalDivider = Container(
          margin: EdgeInsets.fromLTRB(100, 20, 100, 0),
          height: 3,
          color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: HexColor("#3a4256"),
        child: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 100, 0),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
          icon: Icon(Icons.close, size: 30, color: HexColor("#FF784F"),),
          onPressed: () => Navigator.pop(context),
        ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Image.asset("assets/images/bikeshare.png", height: 100, width: 100,),
        horizontalDivider,
        Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BikeList())),
          leading: Icon(Icons.directions_bike, color: Colors.white, size: 30,),
          title: Text("BIKES", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BikeShareMap())),
          leading: Icon(Icons.map, color: Colors.white, size: 30,),
          title: Text("MAP", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RidesHistory())),
          leading: Icon(Icons.list, color: Colors.white, size: 30,),
          title: Text("RIDES", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentHistory())),
          leading: Icon(Icons.attach_money, color: Colors.white, size: 30,),
          title: Text("PAYMENTS", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Credits())),
          leading: Icon(Icons.monetization_on, color: Colors.white, size: 30,),
          title: Text("BALANCE", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 100),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
          leading: Icon(Icons.exit_to_app, color: Colors.white, size: 30,),
          title: Text("LOG OUT", style: TextStyle(fontSize: 22, color: Colors.white, letterSpacing: 4),),
        ),
        
      ],
    ),
      ),
      );
  }
}