import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/Constants.dart';

class PdfUploadScreen extends StatefulWidget {
  final String title;

  const PdfUploadScreen({super.key,required this.title});

  @override
  State<PdfUploadScreen> createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
  File? _selectedPdf;

  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedPdf = File(result.files.first.path!); // Access the path of the first file in the list
        });
      }
    } catch (e) {
      print("Error picking PDF: $e");
    }
  }

  Future<void> _uploadPdf() async {

    if (_selectedPdf == null) {
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.BASE_URL + Constants.PDF_UPLOAD_ROUTE), // Replace with your Django API endpoint
      );
      request.files.add(await http.MultipartFile.fromPath('file', _selectedPdf!.path)); // Using ! to indicate that _selectedPdf is not null
      var response = await request.send();

      if (response.statusCode == 200) {
        print('PDF uploaded successfully');
        // Handle successful upload

        // Display a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );

      } else {
        print('Failed to upload PDF. Status code: ${response.statusCode}');
        // Handle upload failure
      }
    } catch (e) {
      print('Error uploading PDF: $e');
      // Handle upload error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _openFileExplorer,
              child: Text('Select PDF File'),
            ),
            SizedBox(height: 20),
            _selectedPdf != null
                ? Text(
              'Selected PDF: ${_selectedPdf!.path}',
              style: TextStyle(fontSize: 16),
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedPdf != null ? _uploadPdf : null, // Disable button if _selectedPdf is null
              child: Text('Upload PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

