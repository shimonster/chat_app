import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;

  const MessageBubble(this.message, this.isMe, this.key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
          ),
          child: Text(
            message,
            style: TextStyle(
                //color: Theme.of(context).accentColor,
                ),
          ),
        ),
      ],
    );
  }
}
