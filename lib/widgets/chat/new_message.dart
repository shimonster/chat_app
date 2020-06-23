import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.length == 0 || value.length == 1) {
                  setState(() {});
                }
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _messageController.text == ''
                ? null
                : () async {
                    try {
                      FocusScope.of(context).unfocus();
                      await Firestore().collection('chat').add({
                        'text': _messageController.text,
                        'timeStamp': Timestamp.now(),
                      });
                      _messageController.clear();
                    } catch (error) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Couldn\'t send this message.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
