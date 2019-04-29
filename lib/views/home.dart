import 'package:flutter/material.dart';
import 'package:bikeshareapp/views/map.dart';
import 'package:bikeshareapp/views/list_of_bikes.dart';
import 'package:bikeshareapp/views/login_screen.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class Home extends StatefulWidget {
  
  final drawerItems = [
    new DrawerItem("Home(bikelist)", Icons.directions_bike),
    new DrawerItem("Map", Icons.map),
    new DrawerItem("Log out", Icons.exit_to_app)
  ];

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  int _selectedDrawerIndex = 0;

   _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new BikeList();
      case 1:
        return new BikeShareMap();
      case 2:
        return new LoginPage();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Scaffold(
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("bikeshare"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}