import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:mychatapp/widgets/messages.dart';
import 'package:mychatapp/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Onmessage--- >{${message.notification!.body}}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('on background open app--- >{${message.notification!.body}}');
    });
    fcm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Lets Chat',
          ),
          centerTitle: true,
          actions: [
            DropdownButton(
              underline: Container(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  child: SizedBox(
                    child: Row(
                      children: const [
                        Icon(
                          Mdi.logoutVariant,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'Logout',
                ),
              ],
              onChanged: (String? value) {
                if (value == 'Logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ]),
      body: SafeArea(
          child: Column(
        children: const [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      )),
    );
  }
}
