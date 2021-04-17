import 'package:flutter/material.dart';

class BottomNavigationRow extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  _BottomNavigationRowState createState() => _BottomNavigationRowState();
}

class _BottomNavigationRowState extends State<BottomNavigationRow> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            
          ),
        ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black38,
      showSelectedLabels: false,
      onTap: _onItemTapped,
    );
  }
}
