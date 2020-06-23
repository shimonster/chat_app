import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (ctx, i) => Text(snapshot.data.documents[i]['text']),
        );
      },
    );
  }
}
