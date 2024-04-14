import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymatcherf/MyGroupsPage.dart';
import 'package:studymatcherf/profile_page.dart';
import 'package:studymatcherf/searchgroups_page.dart';
import 'package:studymatcherf/settings_page.dart';
import '../Models/UserData.dart';
import 'Functions/create_group.dart'; // Import the CreateGroupPage
import 'searchgroups_page.dart'; // Import the SearchGroupsPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //Selectable Pages on the Nav Bar

  final List<Widget> _pages = [
    CreateGroupPage(),
    MyGroupsPage(),
    SearchGroupsPage(),
    SettingsPage(),
  ];

  //Icons for The Bottom Nav Bar
  final List<Widget> _customIcons = [
    Image.asset(
      'lib/icons/add_group.png',
      width: 40,
      height: 40,
      color: Colors.deepPurple,
    ), // Custom icon for the first item
    Image.asset('lib/icons/group.png',
        width: 40,
        height: 40,
        color: Colors.deepPurple), // Custom icon for the second item
    const Icon(
      Icons.search,
      size: 30,
      color: Colors.deepPurple,
    ),
    const Icon(Icons.settings, size: 30, color: Colors.deepPurple),
  ];

  // State class implementation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The logic of the pages (Starts here)

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        //The logic of the pages (Ends here)
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurple.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,

        items: [
          BottomNavigationBarItem(
            icon: _customIcons[0],
            label: 'CreateGroups',
          ),
          BottomNavigationBarItem(
            icon: _customIcons[1],
            label: 'MyGroups',
          ),
          BottomNavigationBarItem(
            icon: _customIcons[2],
            label: 'SearchGroups',
          ),
          BottomNavigationBarItem(
            icon: _customIcons[3],
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
