import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/list_of_bikes.dart';
import 'package:bikeshareapp/views/add_bike.dart';
import 'package:bikeshareapp/views/map.dart';

class Rides extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RidesState();
  }
}

class _RidesState extends State<Rides> {
  int _currentIndex = 0;
  // Navigate to each view (widget)
  final List<Widget> _children = [
    BikeList(),
    BikeShareMap(),
  ]; 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTabbed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            title: Text("Rides"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text("Camera"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map"),
          )
        ],
      ),
    );
  }

    void onTabTabbed(int index) {
    setState(() {
    _currentIndex = index; 
    });
  }
}

  class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}


