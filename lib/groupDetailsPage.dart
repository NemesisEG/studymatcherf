import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studymatcherf/Models/UserData.dart';
import '../Models/Topic.dart';
import 'group_users_page.dart';

class GroupDetailsPage extends StatefulWidget {
  final Topic topic;

  const GroupDetailsPage({required this.topic});

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  // Controller for the message input field
  final TextEditingController _messageController = TextEditingController();

  // Variable to store the current user's name
  late String _userName;

  // Variable to track loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch user name when the page initializes
    _fetchUserName();
  }

  // Fetch user name from Firestore
  Future<void> _fetchUserName() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    String? name = (userDataSnapshot.data() as Map<String, dynamic>?)?['name'];

    setState(() {
      _userName = name ?? 'Unknown'; // Update user name state
      _isLoading = false; // Mark loading as complete
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading indicator while fetching data
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic.name),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Show chat interface once data is fetched
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: TextButton(
            onPressed: () {
              // Navigate to group users page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupUsersPage(topic: widget.topic),
                ),
              );
            },
            child: Text(
              widget.topic.name,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.deepPurple),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/icons/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StreamBuilder to listen for message updates
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('groupChats')
                    .doc(widget.topic.id)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while fetching messages
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Show message if there are no messages yet
                    return const Expanded(
                      child: Center(child: Text('No messages yet.')),
                    );
                  } else {
                    // Show list of messages
                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var messageData = snapshot.data!.docs[index].data()!;
                          var messageDataMap =
                              messageData as Map<String, dynamic>;

                          // Determine if message is from current user
                          bool isCurrentUserMessage =
                              messageDataMap['sender'] == _userName;

                          return Row(
                            mainAxisAlignment: isCurrentUserMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              // Message bubble
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: isCurrentUserMessage
                                      ? Colors.deepPurple
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Sender's name
                                    Text(
                                      messageDataMap['sender'] ?? 'Unknown',
                                      style: TextStyle(
                                        color: isCurrentUserMessage
                                            ? Colors.white
                                            : Colors.deepPurple,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    // Message text
                                    Text(
                                      messageDataMap['text'] ?? '',
                                      style: TextStyle(
                                        color: isCurrentUserMessage
                                            ? Colors.white
                                            : Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              // Input field for typing messages
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the border radius as needed
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the border radius as needed
                          ),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          hintText: 'Type your message',
                          hintStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ),
                    // Button to send message
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () => _sendMessage(widget.topic.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Send message to Firestore
  void _sendMessage(String groupId) async {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('groupChats')
          .doc(groupId)
          .collection('messages')
          .add({
        'text': messageText,
        'sender': _userName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear(); // Clear message input field
    } catch (e) {
      print('Error sending message: $e');
      // Handle error
    }
  }
}
