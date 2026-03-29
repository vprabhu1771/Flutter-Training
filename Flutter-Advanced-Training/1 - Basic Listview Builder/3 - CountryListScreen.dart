import 'package:flutter/material.dart';

import '../models/Country.dart';

class CountryListScreen extends StatelessWidget {
  
  final List<Country> countries = [
    Country(1, 'United States'),
    Country(2, 'Canada'),
    Country(3, 'United Kingdom'),
    Country(4, 'Australia'),
    Country(5, 'Germany'),
    // Add more countries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country List'),
      ),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(country.id.toString()),
            ),
            title: Text(country.name),
          );
        },
      ),
    );
  }
}