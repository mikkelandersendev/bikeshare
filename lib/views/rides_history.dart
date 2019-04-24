import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/burger_content.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RidesHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RidesHistoryState();
  }
}

class RidesHistoryState extends State<RidesHistory> {

  Widget _ridesList(BuildContext context, DocumentSnapshot document) {
    
    final listSection = SizedBox(
      width: 378,
      child: Card(
        elevation: 8.0,
        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          padding: EdgeInsets.only(left: 1),
          child: Column(
            children: <Widget>[
              Text("Bike: " + document.data["BikeID"].documentID.toString()),
              Text("End location: " + document.data["endLocation"].latitude.toString() + "," + document.data["endLocation"].longitude.toString()),
              Text("Start location: " + document.data["startLocation"].latitude.toString() + "," + document.data["startLocation"].longitude.toString()),
              Text("End Time: " + document.data["endTime"].toDate().toString()),
              Text("Start Time: " + document.data["startTime"].toDate().toString()),
            ],
          ),
          ),
        ),
      );

      return ListTile(
      title: Container(
        child: Row(
          children: <Widget>[listSection],
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete ride entry"),
              content: Text("Deleting ride entry"),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#3a4256"),
      appBar: AppBar(
        backgroundColor: HexColor("#3a4256"),
        elevation: 0,
        centerTitle: true,
        title: Text("History of my rides"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            padding: EdgeInsets.only(right: 10),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BurgerContent())),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: HexColor("#3a4256")),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('Rides')
              .snapshots()
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _ridesList(context, snapshot.data.documents[index]),
            );
          },
        ),
    ),
    );
  }

}