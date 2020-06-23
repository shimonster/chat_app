import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore()
              .collection('chat')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              reverse: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (ctx, i) {
                final docs = snapshot.data.documents;
                return MessageBubble(
                  docs[i]['text'],
                  futureSnapshot.data.uid == docs[i]['uid'],
                  ValueKey(docs[i].documentID),
                );
              },
            );
          },
        );
      },
    );
  }
}
