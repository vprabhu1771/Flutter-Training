import 'package:flutter/material.dart';
import 'package:untitled/screens/ImageUploadScreen.dart';
import 'package:untitled/screens/PDFUploadScreen.dart';
import 'package:untitled/screens/VideoUploadScreen.dart';

import 'ImageUploadScreen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Image Upload'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ImageUploadScreen(title: 'Image Upload')),
                );
              },
            ),
            ListTile(
              title: const Text('Video Upload'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VideoUploadScreen(title: 'Video Upload')),
                );
              },
            ),
            ListTile(
              title: const Text('PDF Upload'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PdfUploadScreen(title: 'PDF Upload')),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
