// lib/core/widgets/custom_photo_uploader.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomPhotoUploader extends StatefulWidget {
  const CustomPhotoUploader({super.key});

  @override
  _CustomPhotoUploaderState createState() => _CustomPhotoUploaderState();
}

class _CustomPhotoUploaderState extends State<CustomPhotoUploader> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null ? null : FileImage(File(_imageFile!.path)),
            child: _imageFile == null
                ? const Icon(Icons.person, size: 80, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
