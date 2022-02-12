import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _message = '';
  final _controller = TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    var userID = FirebaseAuth.instance.currentUser;
    // print(userID?.uid);
    FirebaseFirestore.instance.collection('chat').add({
      'text': _message,
      'createdAt': Timestamp.now(),
      'UserID': userID?.uid,
    });
    _message = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Send the message...',
            ),
            onChanged: (value) {
              setState(() {
                _message = value.trim();
              });
            },
          ),
        ),
        IconButton(
          onPressed: _message.isEmpty ? null : _sendMessage,
          icon: Icon(
            Icons.send,
            color: _message.isEmpty ? null : Colors.indigo,
          ),
        ),
      ],
    );
  }
}
