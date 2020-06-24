import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String uid;
  final bool isMe;
  final Key key;

  const MessageBubble(
      this.message, this.username, this.uid, this.isMe, this.key)
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(!isMe ? 0 : 12),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
                color: isMe ? Colors.green[100] : Colors.deepPurple[100],
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 3 / 4,
                minWidth: username.length * 5.0 + 50,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 10,
                    ),
                  ),
                  Text(message),
                ],
              ),
            ),
            Positioned(
              top: -10,
              left: !isMe ? 3 : null,
              right: isMe ? 3 : null,
              child: FutureBuilder(
                future: Firestore.instance.document('users/$uid').get(),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? CircleAvatar()
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data['url'] ??
                                  'https://lh3.googleusercontent.com/proxy/GnQJWh446SEH8UCx3X230tslq6LvZUjPvVjjN0ygrClPdN1RLbfI6IxAsfB4Zg5ER6KNpll5VPS5gVeJppJfvC5pxVPR1fL5BjqwPJatLgdU5XYRr2xPZ6Yy1L3SqM8dLpvhtmVlhke2dno7aTPMcFDmQWvHHkByT-If35ItYl_tFVXznE7VSWQFx7UD9m0',
                            ),
                          ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
