import 'package:Tocsin/Component/custom_icons.dart';
import 'package:flutter/material.dart';
import 'crime.dart';
import 'sos.dart';
import 'more.dart';

class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    CrimePage(),
    SosPage(),
    MorePage(),
  ];
  List<BottomNavigationBarItem> _menuBar
  = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.location),
      title: Text('CRIME'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.sos),
      title: Text('SOS'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.more),
      title: Text('MORE'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: _menuBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.primary,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}