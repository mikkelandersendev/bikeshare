import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/views/rent_bike.dart';

class BikeShareMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BikeShareMapState();
  }
}

class BikeShareMapState extends State<BikeShareMap> {

  BikeShareMapState() {
    _setBikeMarker();
  }

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> bikeMarkers = {};
  int _markerIdCounter = 0;

  static final CameraPosition _itu = CameraPosition(
    target: LatLng(55.659889, 12.591230),
    zoom: 14.4746,
  );

  static final CameraPosition _toITU = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(55.659889, 12.591230),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(bikeMarkers.values),
        mapType: MapType.hybrid,
        myLocationEnabled: true,
        initialCameraPosition: _itu,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('TO ITU'),
        backgroundColor: HexColor("#FF784F"),
        foregroundColor: Colors.white,
        icon: Icon(Icons.school),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_toITU));
  }

  Set<Marker> _setBikeMarker() {
    Firestore.instance
        .collection("Bikes")
        .where("available", isEqualTo: true)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        final markerIdValue = _generateMarkerId();
        final markerId = MarkerId(markerIdValue);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(doc["currentLocation"].latitude,
              doc["currentLocation"].longitude),
          infoWindow: InfoWindow(
              title: markerIdValue,
              snippet: doc["bikeName"],
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RentBike(doc)));
              }),
          visible: true,
        );
        setState(() {
          bikeMarkers[markerId] = marker;
        });
      });
    });
  }

  String _generateMarkerId() {
    return "marker_id_${_markerIdCounter++}";
  }
}
