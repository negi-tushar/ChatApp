import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mychatapp/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isloading = false;
  void _submitForm(
    String email,
    String uname,
    File image,
    String password,
    bool isLogin,
  ) async {
    try {
      setState(() {
        _isloading = true;
      });
      if (!isLogin) {
        final authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print('object');
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
// Storing image file to firebase storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(image);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': uname,
          'email': email,
          'password': password,
          'image_URL': url,
        });

        print('signup');
      }
    } on PlatformException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.green,
        ),
      );
      if (mounted) {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.green,
        ),
      );
    }
    if (mounted) {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitFn: _submitForm, isLoading: _isloading),
    );
  }
}
