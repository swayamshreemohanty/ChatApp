import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn); //this is constructor

  final void Function(File pickedImage) imagePickFn; // this is the property

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    try {
      final pickedImageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 50,
        maxWidth: 150,
      );
      if (pickedImageFile == null) {
        return;
      }
      setState(() {
        _pickedImage = File(pickedImageFile.path);
        //set the path of the temporary clicked image as file using File().
      });
      widget.imagePickFn(_pickedImage!);
    } on PlatformException {
      print("Failed to pick image");
    } catch (error) {
      print("Failed to pick image on catch");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}
