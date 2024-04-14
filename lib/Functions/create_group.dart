import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'C R E A T E   Y O U R   O W N   G R O U P',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: topicController,
              style: TextStyle(color: Colors.white), // Change text color to white
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Color.fromARGB(255, 33, 33, 33),
                filled: true,
              ),
            ),
            const SizedBox(
                height: 10), // Add space between TextField and Button
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _createGroup(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 2), // Adjust the offset as needed
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'lib/icons/add_group1.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroup(BuildContext context) async {
    String topicName = topicController.text.trim();

    if (topicName.isEmpty) {
      _showErrorDialog(context, 'Error', 'Please enter a topic.');
      return;
    }

    try {
      String topicId = FirebaseFirestore.instance.collection('topics').doc().id;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('topics').doc(topicId).set({
        'id': topicId,
        'name': topicName,
        'createdBy': userId,
        'joinedUsers': [userId], // Add the creator to the joined users list
      });

      _showSuccessDialog(context);
    } catch (e) {
      print('Error creating group: $e');
      _showErrorDialog(
          context, 'Error', 'Failed to create group. Please try again later.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Group created successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
