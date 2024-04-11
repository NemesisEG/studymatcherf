import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:studymatcherf/MyGroupsPage.dart';
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

  final List<Widget> _pages = [
    CreateGroupPage(),
    MyGroupsPage(),
    SearchGroupsPage(),
    SettingsPage(),
    
  ];

  // State class implementation
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 63, 62, 62),
            padding: EdgeInsets.all(16),
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home,
                text: "CreateGroups",
              ),
              GButton(
                icon: Icons.favorite,
                text: "MyGroups",
              ),
              GButton(
                icon: Icons.search,
                text: "SearchGroups",
              ),
              GButton(
                icon: Icons.settings,
                text: "Settings",
              ),
              
            ],
          ),
        ),
      ),
    );
    
  }
}
