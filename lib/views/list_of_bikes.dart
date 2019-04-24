import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikeshareapp/views/add_bike.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/components/vertical_divider.dart';
import 'package:bikeshareapp/views/burger_content.dart';
import 'package:bikeshareapp/views/rent_bike.dart';
import 'package:geolocator/geolocator.dart';

class BikeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BikeListState();
  }
}

class BikeListState extends State<BikeList> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Column(
        children: <Widget>[
          Image.network(
            document["image"],
            height: 90,
            width: 100,
          ),
          Text(document["bikeName"]),
          // Text("Address: " + translateLatLon().toString()),
          // Text("Latitude: " +
          //     document["currentLocation"].latitude.toString() +
          //     " Longitude: " +
          //     document["currentLocation"].longitude.toString()),
        ],
      ),
      enabled: true,
      isThreeLine: false,
      onTap: () => print("I was pressed"),
      onLongPress: () => print("I was pressed for long"),
    );
  }

  Widget _bikeList(BuildContext context, DocumentSnapshot document) {
    
    Future<String> translateLatLon() async {
      var lat = document["currentLocation"].latitude;
      var lon = document["currentLocation"].longitude;
      var address = await Geolocator().placemarkFromCoordinates(lat, lon);
      return address[0].thoroughfare;
    }

    final leftSection = Container(
      child: Image.network(
        document["image"],
        height: 100.0,
        width: 100.0,
      ),
    );

    final midSection = Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                      ),
                      Icon(Icons.directions_bike,
                          color: Colors.white, size: 30),
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        document["bikeName"],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
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
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final rightSection = Container(
      margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: HexColor("#FF784F"),
      ),
    );

    final newMidSection = SizedBox(
      width: 378,
      child: Card(
        elevation: 8.0,
        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          padding: EdgeInsets.only(left: 1),
          child: Row(
            children: <Widget>[
              leftSection,
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              BikeShareVerticalDivider(),
              midSection,
              rightSection
            ],
          ),
        ),
      ),
    );

    return ListTile(
      title: Container(
        child: Row(
          children: <Widget>[newMidSection],
        ),
      ),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => RentBike(document))),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Warning: Delete ${document.data["bikeName"]}"),
              content: Text("Deleting ${document.data["bikeName"]}"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Delete"),
                  onPressed: () {
                    Firestore.instance.document(document.reference.path).delete();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bikes"),
        elevation: 0,
        backgroundColor: HexColor("#3a4256"),
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddBike())),
        label: Text("ADD BIKE"),
        icon: Icon(Icons.add),
        backgroundColor: HexColor("#FF784F"),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: BoxDecoration(color: HexColor("#3a4256")),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('Bikes')
              .snapshots()
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Loading data...");
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _bikeList(context, snapshot.data.documents[index]),
            );
          },
        ),
      ),
    );
  }
}
