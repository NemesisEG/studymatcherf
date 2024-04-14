import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/UserData.dart';
import '../Models/Topic.dart';

class GroupUsersPage extends StatelessWidget {
  final Topic topic;

  const GroupUsersPage({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'U S E R S',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
          ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: topic.joinedUsers)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userData = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                var userName = userData['name'] as String?; // Add explicit type annotation
                var userEmail = userData['email'] as String?; // Add explicit type annotation

                return ListTile(
                  title: Text(userName ?? 'Unknown'),
                  subtitle: Text(userEmail ?? 'No email'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

