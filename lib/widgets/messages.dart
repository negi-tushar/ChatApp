import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<User?> _getUserID() async {
      return FirebaseAuth.instance.currentUser;
    }

    return FutureBuilder(
      future: _getUserID(),
      builder: (context, AsyncSnapshot<User?> futuresnap) {
        if (futuresnap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SingleChildScrollView(),
                );
              }
              final chatDocs = snap.data!.docs;

              print('future ---${futuresnap.data!.uid}');

              return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                        isMe: chatDocs[index]['UserID'] == futuresnap.data!.uid,
                        message: chatDocs[index]['text'].toString());
                  });
            });
      },
    );
  }
}
