import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymatcherf/Functions/google_auth.dart';

class ProfilePage extends StatefulWidget {
  final GoogleAuth _googleAuth = GoogleAuth();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isEditingName = false;
  String _originalName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'P R O F I L E',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _isEditingName
            ? [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditingName = false;
                      _nameController.text = _originalName;
                    });
                  },
                  icon: Icon(Icons.cancel),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isEditingName = false;
                      _originalName = _nameController.text;
                      // Save changes to database here
                      updateUserDisplayName(_nameController.text);
                    });
                  },
                  icon: Icon(Icons.check),
                ),
              ]
            : [],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
          _phoneNumberController.text = userData['phoneNumber'] ?? 'N/A';
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center( // Center the circular avatar
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              userData['name'][0], // Display first letter of the name
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingName = true;
                              _originalName = _nameController.text; // Assigning the current name to _originalName
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  enabled: _isEditingName,
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userData['email'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userData['phoneNumber'] ?? 'N/A',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await widget._googleAuth.signOut();
                    Navigator.pushNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> updateUserDisplayName(String newName) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': newName});

      // Update the state to reflect the new name
      setState(() {
        _originalName = newName;
      });
    } catch (error) {
      print('Error updating name: $error');
    }
  }
}
