import 'package:flutter/material.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/views/burger_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Credits extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreditsState();
  }
}

class CreditsState extends State<Credits> {
  void topUp() {
    Firestore.instance.document("Balance/FhlZSkVxkI9tjCO2F9uC").updateData({
      "balance": 1000,
    });
  }

  @override
  Widget build(BuildContext context) {
    final BikeShareTopUpButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#404b60"),
      child: MaterialButton(
          minWidth: 250,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: topUp,
          child: Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 20,
          )),
    );

    return Scaffold(
      backgroundColor: HexColor("#3a4256"),
      appBar: AppBar(
        backgroundColor: HexColor("#3a4256"),
        elevation: 0,
        centerTitle: true,
        title: Text("My balance"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            padding: EdgeInsets.only(right: 10),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => BurgerContent())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
        label: Text("Add credits (BSC)"),
        backgroundColor: HexColor("#FF784F"),
        foregroundColor: Colors.white,
        onPressed: () => topUp(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
          stream: Firestore.instance
              .document("Balance/FhlZSkVxkI9tjCO2F9uC")
              .snapshots()
              .asBroadcastStream(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return CircularProgressIndicator();
            }
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 150),
                  ),
                  Icon(
                    Icons.attach_money,
                    size: 80,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Text(
                    "Your current balance: ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    snap.data["balance"].toString() + " BSC",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
