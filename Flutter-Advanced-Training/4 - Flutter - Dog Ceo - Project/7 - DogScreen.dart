import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/Dog.dart';
import '../util/Constants.dart';

class DogScreen extends StatefulWidget {

  final String title;

  const DogScreen({super.key, required this.title});

  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {

  Dog? dog;

  Future<void> fetchDogImage() async {

    final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.RANDOM_DOG_IMAGE));

    if (response.statusCode == 200)
    {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        dog = Dog.fromJson(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: dog != null
            ? Image.network(
          dog!.message,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
