import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bikeshareapp/components/bikeshare_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bikeshareapp/util/hexcolor.dart';
import 'package:bikeshareapp/views/burger_content.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class AddBike extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddBikeState();
  }
}

class AddBikeState extends State<AddBike> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final bikeshareNameController = TextEditingController();
  final priceController = TextEditingController();
  File _image;
  
  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);

    setState(() {
      _image = image;
    });
  }

  Future<String> uploadImage() async {
    final String fileNameID = Random().nextInt(10000).toString() + "." + basename(_image.path);
    final StorageReference storageReference = FirebaseStorage.instance.ref().child(fileNameID);
    final StorageUploadTask uploadTask = storageReference.putFile(_image);
    final StorageTaskSnapshot snapshot = (await uploadTask.onComplete);

    return (await snapshot.ref.getDownloadURL());
  }

  Future<GeoPoint> getLocation() async {
  try {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    List<Placemark> addr = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    print(addr[0].thoroughfare);
    return GeoPoint(position.latitude, position.longitude);
  } on PlatformException catch (_) {
    print("getLocation messed up");
  }
}

  Widget showImage() {
    return FutureBuilder<File>(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot){
        if(snapshot.data != null) 
        {
          return Image.file(
            //_image
            snapshot.data,
            width: 300,
            height: 300,
            );
        } else if (snapshot.error != null)
        {
          return const Text(
            "Error picking file",
            textAlign: TextAlign.center,
          );
        } else 
        {
          return const Text(
            "No image selected",
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {

    final BikeShareCameraButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#404b60"),
      child: MaterialButton(
        minWidth: 250,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: getImageFromCamera,
        child: Icon(Icons.camera_alt, color: Colors.white,)
      ),
    );

    final BikeShareGalleryButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#404b60"),
      child: MaterialButton(
        minWidth: 250,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: getImageFromGallery,
        child: Icon(Icons.image, color: Colors.white,)
      ),
    );

    final BikeShareLocationButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#404b60"),
      child: MaterialButton(
        minWidth: 250,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => getLocation(),
        child: Icon(Icons.location_on, color: Colors.white,)
      ),
    );

    final BikeShareSaveButton = Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(30.0),
      color: HexColor("#FF784F"),
      child: MaterialButton(
        minWidth: 250,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Firestore.instance.collection("Bikes").add({
            "bikeName": bikeshareNameController.text,
            "currentLocation": GeoPoint(double.tryParse(latitudeController.text), double.tryParse(longitudeController.text)),
            "image": await uploadImage(),
            "price": double.tryParse(priceController.text),
          });
        },
        child: Text("SAVE BIKE", style: TextStyle(color: Colors.white, fontSize: 18),)
      ),
    );


    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add new bike"),
        elevation: 0,
        backgroundColor: HexColor("#3a4256"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            padding: EdgeInsets.only(right: 10),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BurgerContent())),
          ),
        ],
      ),
      backgroundColor: HexColor("#3a4256"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Container(
              width: 250,
              child: BikeShareTextField("Enter name of bike", bikeshareNameController),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            BikeShareCameraButton,
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            BikeShareGalleryButton,
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            BikeShareLocationButton,
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: BikeShareTextField("LAT", latitudeController),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
                Container(
                  width: 120,
                  child: BikeShareTextField("LON", longitudeController),
                ),
              ],
            ),
          Padding(
                padding: EdgeInsets.only(top: 15),
            ),
          Container(
              width: 250,
              child: BikeShareTextField("Price per minute", priceController),
            ),
          Padding(
                padding: EdgeInsets.only(top: 15),
            ),
          BikeShareSaveButton,
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          _image != null ? Image.file(_image, width: 200, height: 200,) : Text("No image selected", style: TextStyle(color: Colors.white, fontSize: 16),)
          ],
        ),
      ),
    ),
    );
  }
}
