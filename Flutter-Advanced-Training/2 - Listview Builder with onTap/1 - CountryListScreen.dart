import 'package:flutter/material.dart';

import '../models/Country.dart';

class CountryListScreen extends StatelessWidget {

  final List<Country> countries = [
    Country(1, 'India'),
    Country(2, 'United States'),
    Country(3, 'Canada'),
    Country(4, 'United Kingdom'),
    Country(5, 'Australia'),
    Country(6, 'Germany'),
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
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Clicked on ${country.name}'),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(country.id.toString()),
              ),
              title: Text(country.name),
            ),
          );
        },
      ),
    );
  }
}