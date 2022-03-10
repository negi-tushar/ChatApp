import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mychatapp/widgets/user_image.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  final void Function(
    String email,
    String uname,
    File image,
    String password,
    bool isLogin,
  ) submitFn;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  var _userEmail = '';
  var _username = '';
  var _userPassword = '';
  var _fetchedImage;

  void setImage(File image) {
    _fetchedImage = image;
  }

  void _trySubmit() {
    //  print(_fetchedImage);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_fetchedImage == null && _isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Please select a Picture!',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red.shade500,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      // print(_userPassword);
      widget.submitFn(
        _userEmail,
        _username,
        _fetchedImage,
        _userPassword,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLogin) UserImage(pickedImageFn: setImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (!value!.contains('@') && value.isEmpty) {
                        return 'Please enter valid email address';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('email address'),
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: const ValueKey('uname'),
                      validator: (value) {
                        if (value!.length < 3) {
                          return 'Please enter valid UserName';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Username'),
                      ),
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.length < 3 || value.isEmpty) {
                        return 'Password must be greater than 3 char';
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  if (widget.isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: () {
                        _trySubmit();
                      },
                      child: Text(!_isLogin ? 'Login' : 'Sign Up'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(!_isLogin
                          ? 'Create New Account'
                          : 'Already have a Account'),
                    ),
                ],
              )),
        )),
      ),
    );
  }
}
