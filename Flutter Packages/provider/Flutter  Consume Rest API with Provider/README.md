
# https://www.youtube.com/watch?v=EnAN3WGpFtk&list=PLpTC1FqgUpLRhzinu-4tSW4eMkxzwOEcx
```dart
class Category {

  final int id;
  final String name;

  Category({
    required this.id,
    required this.name
  });

  Category.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'];

}
```

```dart
class Constants{

  static const String SERVER_DOMAIN = "http://192.168.1.211:8000";

  static const String BASE_URL = SERVER_DOMAIN + "/api";

  static const String CATEGORY_ROUTE = "/categories";

}
```

`CategoryProvider.dart`

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/Category.dart';
import '../utils/Constants.dart';

class CategoryProvider extends ChangeNotifier
{

  bool isLoading = true;

  String error = '';

  late List<Category> categories = [];

  // Fetch data from the API
  Future<void> fetchData() async
  {

    isLoading = true;

    notifyListeners();

    try {
      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.CATEGORY_ROUTE));

      print(response.statusCode);

      print(Constants.BASE_URL + Constants.CATEGORY_ROUTE);
      print(error);
      if (response.statusCode == 200)
      {

        final List<dynamic> data = json.decode(response.body)['data'];

        categories = data.map((category) => Category.fromJson(category)).toList();

        isLoading = false;

      }
      else
      {

        // More specific error handling can be added here
        throw Exception('Failed to load categories: ${response.statusCode}');

      }
    }
    catch (e)
    {

      // Log error or handle differently
      print('Error: $e');

      error = 'Error: $e';

      isLoading = false;

    }
    finally
    {
      notifyListeners();
    }

  }

}
```

```dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled/services/CategoryProvider.dart';

import '../model/Category.dart';

class CategoryScreen extends StatefulWidget {

  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is first initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {

    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      body: categoryProvider.isLoading
          ? getLoadingUI()
          : categoryProvider.error.isNotEmpty
          ? getErrorUI(categoryProvider.error)
          : getBodyUI(categoryProvider.categories)
    );
  }

  Widget getLoadingUI()
  {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SpinKitFadingCircle(
            color: Colors.orange,
            size: 50.0,
          ),
          const Text(
            "Loading...",
            style: TextStyle(color: Colors.blue, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget getErrorUI(String error)
  {
    return Center(
      child: Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: 22),
      ),
    );
  }

  Widget getBodyUI(List<Category> categories)
  {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(categories[index].name),
        ),
    );
  }
}
```

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/CategoryScreen.dart';
import 'package:untitled/services/CategoryProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        // ChangeNotifierProvider(create: (context) => PlaylistProvider()), // Fixed typo here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryScreen(title: 'Category'),
    );
  }
}
```