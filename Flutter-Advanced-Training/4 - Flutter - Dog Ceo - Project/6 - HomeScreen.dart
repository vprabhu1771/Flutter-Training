import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dog_ceo/util/Constants.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  String imageUrl = "";

  Future<void> fetchDogImage() async {

    final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.RANDOM_DOG_IMAGE));

    if (response.statusCode == 200)
    {

      final Map<String, dynamic> data = json.decode(response.body);

      print(response.toString());

      setState(() {
        imageUrl = data['message'];
      });

    }
    else
    {
      throw Exception("Failed to load image");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDogImage();
  }

  Future<void> _handleRefresh() async {
    await fetchDogImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _handleRefresh();
            },
          ),
        ],
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
