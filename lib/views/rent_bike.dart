import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/burger_content.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class RentBike extends StatefulWidget {
  DocumentSnapshot _bikeSnapshot;

  RentBike(DocumentSnapshot snapshot) {
    _bikeSnapshot = snapshot;
  }

  @override
  State<StatefulWidget> createState() {
    return RentBikeState();
  }
}

class RentBikeState extends State<RentBike> {
  Future<GeoPoint> getLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      return GeoPoint(position.latitude, position.longitude);
    } on PlatformException catch (_) {
      print("getLocation messed up");
    }
  }

  Future<String> translateLatLon() async {
    var lat = widget._bikeSnapshot["currentLocation"].latitude;
    var lon = widget._bikeSnapshot["currentLocation"].longitude;
    var address = await Geolocator().placemarkFromCoordinates(lat, lon);
    return address[0].thoroughfare;
  }

  Future startRide(DocumentSnapshot document) async {
    var currentTime = DateTime.now();
    var currentLocation = await getLocation();

    Firestore.instance.collection("Rides").add({
      "BikeID": document.reference,
      "endLocation": null,
      "endTime": null,
      "startLocation": currentLocation,
      "startTime": currentTime
    });

    // updates the bike data
    Firestore.instance.document(document.reference.path).updateData({
      "available": false,
      "currentLocation": currentLocation,
    });
  }

  Future endRide(DocumentSnapshot document) async {
    var currentTime = DateTime.now();
    var currentLocation = await getLocation();

    Firestore.instance
        .collection("Rides")
        .where(
          "BikeID",
          isEqualTo: document.reference,
        )
        .getDocuments()
        .then((querySnapshot) {
      var fetchRide = querySnapshot.documents
          .where((d) => d.data["endLocation"] == null)
          .first;
      var timeDifference =
          currentTime.difference(fetchRide["startTime"].toDate());
      var totalDifference = timeDifference.inSeconds * document.data["price"];

      Firestore.instance
          .document("Balance/FhlZSkVxkI9tjCO2F9uC")
          .get()
          .then((doc) {
        Firestore.instance.document("Balance/FhlZSkVxkI9tjCO2F9uC").updateData({
          "balance": doc.data["balance"] - totalDifference,
        });

        Firestore.instance.collection("Payments").add({
          "ride": fetchRide.reference,
          "total": totalDifference,
          "balance": doc.reference,
        });
      });
      Firestore.instance
          .document(fetchRide.reference.path)
          .updateData({"endTime": currentTime, "endLocation": currentLocation});
    });

    // Update bike info
    Firestore.instance.document(document.reference.path).updateData({
      "available": true,
      "currentLocation": currentLocation,
    });
  }

  @override
  Widget build(BuildContext context) {
    final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: 200,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/rentbike.jpg"),
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
            child: Text(
              widget._bikeSnapshot.data["bikeName"],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          left: 14.55,
          top: 40.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ],
    );

    final bikeLocation = Column(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: Colors.white,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "Current location",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        StreamBuilder(
          stream: translateLatLon().asStream(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return CircularProgressIndicator();
            }
            return Text(
              "${snap.data}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );

    final price = Column(
      children: <Widget>[
        Icon(
          Icons.attach_money,
          color: Colors.white,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "Price per minute",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          widget._bikeSnapshot["price"].toString() + " BSC",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );

    var date = DateTime.now().toLocal().toString();

    final currentTime = Column(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.white,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "Current time / time at rent",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          date.substring(0, 19),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );

    var _startedTime = "";
    var _endedTime = "";

    final bikeShareStartButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#FF784F"),
      child: MaterialButton(
        minWidth: 250,
        child: Text(
          "START RIDE",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async => await startRide(widget._bikeSnapshot),
      ),
    );

    final bikeShareEndButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#FF784F"),
      child: MaterialButton(
        minWidth: 250,
        child: Text(
          "END RIDE",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async => await endRide(widget._bikeSnapshot),
      ),
    );

    return Scaffold(
      backgroundColor: HexColor("#3a4256"),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: Firestore.instance
                .document(widget._bikeSnapshot.reference.path)
                .snapshots()
                .asBroadcastStream(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return CircularProgressIndicator();
              }
              return Column(
                children: <Widget>[
                  topContent,
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  bikeLocation,
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  price,
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  currentTime,
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                  ),
                  snap.data["available"]
                      ? bikeShareStartButton
                      : bikeShareEndButton,
                ],
              );
            }),
      ),
    );
  }
}
