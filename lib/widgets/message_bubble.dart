import 'package:flutter/material.dart';
import 'package:mychatapp/main.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, required this.isMe, Key? key})
      : super(key: key);

  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.8,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
          decoration: BoxDecoration(
            color: isMe ? Colors.indigo : Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomRight:
                  !isMe ? const Radius.circular(20) : const Radius.circular(0),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(20),
            ),
          ),
          child: Text(
            message,
            //overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
