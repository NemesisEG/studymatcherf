import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Topic.dart'; // Import the Topic class

class SearchGroupsPage extends StatefulWidget {
  @override
  _SearchGroupsPageState createState() => _SearchGroupsPageState();
}

class _SearchGroupsPageState extends State<SearchGroupsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'S E A R C H  G R O U P S',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fillColor: Colors.grey.shade300,
                filled: true,
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.deepPurple),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild when search query changes
              },
            ),
          ),
          const SizedBox(height: 10.0), // Added SizedBox with a height of 16.0
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('topics').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No groups found.'));
                } else {
                  List<Topic> groups = snapshot.data!.docs
                      .map((doc) => Topic.fromMap(doc.data()!))
                      .toList();

                  // Filter groups based on search query
                  final query = _searchController.text.toLowerCase();
                  if (query.isNotEmpty) {
                    groups = groups
                        .where((group) => _containsSubstrings(
                            group.name.toLowerCase(), query))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      Topic topic = groups[index];
                      return GestureDetector(
                        onTap: () {
                          _joinGroup(topic.id);
                        },
                        child: Card(
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
                            trailing: _buildJoinButton(topic),
                            // Add any other relevant information about the group
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20.0), // Added SizedBox with a height of 16.0
        ],
      ),
    );
  }

  // Function to check if the group name contains any part of the query
  bool _containsSubstrings(String groupName, String query) {
    int queryIndex = 0;
    for (int i = 0; i < groupName.length; i++) {
      if (groupName[i] == query[queryIndex]) {
        queryIndex++;
        if (queryIndex == query.length) {
          return true;
        }
      }
    }
    return false;
  }

  Widget _buildJoinButton(Topic topic) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    bool isUserJoined = topic.joinedUsers.contains(userId);
    return ElevatedButton(
        onPressed: isUserJoined ? null : () => _joinGroup(topic.id),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              // Color when button is disabled (User has already joined)
              return Colors.grey.shade800;
            }
            // Color when button is enabled (User has not joined yet)
            return Colors.deepPurple;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the radius as needed
            ),
          ),
        ),
        child: Text(isUserJoined ? 'Joined' : 'Join',
            style: const TextStyle(
              fontSize: 12.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            )));
  }

  void _joinGroup(String groupId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(groupId)
          .update({
        'joinedUsers': FieldValue.arrayUnion([userId]),
      });
      // Show success message or navigate to a different page
    } catch (e) {
      print('Error joining group: $e');
      // Show error message
    }
  }
}
