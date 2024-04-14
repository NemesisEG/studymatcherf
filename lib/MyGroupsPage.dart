import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../Models/Topic.dart';
import 'groupDetailsPage.dart';

class MyGroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: const Text(
            'M Y    G R O U P S',
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),

          //Start of the Logic of extracting the groups joined by the user

          child: StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('topics')
                .where('joinedUsers', arrayContains: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                  'Go Find Some Study Buddies!',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      // fontWeight: FontWeight.bold,
                      fontSize: 25),
                ));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>> groupSnapshot =
                        snapshot.data!.docs[index]
                            as QueryDocumentSnapshot<Map<String, dynamic>>;
                    Topic topic = Topic.fromMap(groupSnapshot.data());

                    //End of the Logic of extracting the groups joined by the user

                    //Designing the List of Groups Joined

                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius as needed
                          ),
                          color: Colors.grey[
                              900], // Change the color to your desired color
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            title: Text(
                              topic.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GroupDetailsPage(topic: topic),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
