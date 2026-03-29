import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/Constants.dart';

class ImageUploadScreen extends StatefulWidget {

  final String title;

  const ImageUploadScreen({super.key, required this.title});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future uploadImage() async {
    if (_imageFile == null) {
      // Handle case when no image is selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Constants.BASE_URL + Constants.IMAGE_UPLOAD_ROUTE), // Replace with your Django API endpoint
    );
    request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded');

        // Display a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error
        print('Failed to upload image');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(
              _imageFile!,
              height: 150,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: getImageFromGallery,
                  child: Text('Pick Image'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: getImageFromCamera,
                  child: Text('Take Picture'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
