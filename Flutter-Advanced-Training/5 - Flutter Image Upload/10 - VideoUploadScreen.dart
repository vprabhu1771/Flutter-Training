import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/Constants.dart';

class VideoUploadScreen extends StatefulWidget {
  final String title;

  const VideoUploadScreen({super.key, required this.title});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  Future getVideoFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  Future getVideoFromCamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  Future uploadVideo() async {
    if (_videoFile == null) {
      // Handle case when no video is selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Constants.BASE_URL + Constants.VIDEO_UPLOAD_ROUTE),
    );
    request.files.add(await http.MultipartFile.fromPath('file', _videoFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Video uploaded successfully
        print('Video uploaded');

        // Display a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error
        print('Failed to upload video');
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
            _videoFile == null
                ? Text('No video selected.')
                : Text('Video selected: ${_videoFile!.path}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: getVideoFromGallery,
                  child: Text('Pick Video'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: getVideoFromCamera,
                  child: Text('Record Video'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadVideo,
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
