import 'package:flutter/material.dart';

import '../models/Country.dart';

class CountryDetailScreen extends StatelessWidget {

  final Country country;

  CountryDetailScreen({required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: Center(
        child: Text('Country ID: ${country.id}\nCountry Name: ${country.name}'),
      ),
    );
  }

}