import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymatcherf/MyGroupsPage.dart';
import '../Models/UserData.dart';
import 'Functions/create_group.dart'; // Import the CreateGroupPage
import 'searchgroups_page.dart'; // Import the SearchGroupsPage

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'H O M E  P A G E',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
      ),
      //Working on the Home Page

      backgroundColor: Colors.grey[300],



      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              UserData userData = UserData.fromJson(snapshot.data!.data()!);
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome,',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          userData.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Create Group'), // New button
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateGroupPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Search Groups'), // New button
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchGroupsPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to settings page
                      // Add your navigation logic here
                    },
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('My Groups'), // New section
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyGroupsPage(),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Logged in successfully!'),
          ],
        ),
      ),
    );
  }
}
