import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => Container(
          child: Text('cool'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/yoD62921qQ80MpQKHFmH/messages')
              .snapshots()
              .listen(
            (event) {
              event.documents.forEach(
                (document) => print(document['text']),
              );
            },
          );
        },
      ),
    );
  }
}
