# 1 - Basic Listview Builder

1. Folder Setup

```
lib -> models

lib -> screens

lib -> models -> Country.dart

lib -> screens -> CountryListScreen.dart
```

2. `Country.dart`

```
class Country {

  final int id;

  final String name;

  Country(this.id, this.name);

}
```

3. `CountryListScreen.dart`

```
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
```

![Image](4.png)