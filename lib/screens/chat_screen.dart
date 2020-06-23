import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Chat'),
        actions: <Widget>[
          DropdownButton(
            onChanged: (_) {
              FirebaseAuth.instance.signOut();
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
