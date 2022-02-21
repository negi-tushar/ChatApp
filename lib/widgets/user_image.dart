import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  const UserImage({required this.pickedImageFn, Key? key}) : super(key: key);

  final void Function(File image) pickedImageFn;
  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _fetchedImage;
  void _pickImage() async {
    var image = ImagePicker();
    final _pickedImage = await image.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 80,
        maxHeight: 110);
    setState(() {
      _fetchedImage = File(_pickedImage!.path);
    });
    widget.pickedImageFn(File(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _fetchedImage == null ? null : FileImage(_fetchedImage!),
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture')),
      ],
    );
  }
}
