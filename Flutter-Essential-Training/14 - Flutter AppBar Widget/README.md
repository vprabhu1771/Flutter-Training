# 14 - Flutter AppBar Widget

1. CategoryScreen.dart - Default App Bar

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](2.png)

3. CategoryScreen.dart - App Bar With Centered Text

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](4.png)

5. CategoryScreen.dart - App Bar With IconButton, actions

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
        actions: <Widget>[
          IconButton( 
            icon: Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Notifications Works")),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](6.png)
![Image](7.png)

8. CategoryScreen.dart - App Bar With IconButton, actions, label

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
        actions: <Widget>[
          IconButton( 
            icon: Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Notifications Works"),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                    ),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](9.png)
![Image](10.png)

11. CategoryScreen.dart - App Bar With background color

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
        actions: <Widget>[
          IconButton( 
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.orangeAccent,
        
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](12.png)

13. CategoryScreen.dart - App Bar With Menu Icon

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
        actions: <Widget>[
          IconButton( 
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Menu Works"),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                    ),
                ),
              );
            },
        ),
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](14.png)
![Image](15.png)

16. CategoryScreen.dart - App Bar With Rounded Shape

```
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Screen'),
        centerTitle: true,
        actions: <Widget>[
          IconButton( 
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        ),
      ),
      body: Center(
        child: Text('Hello, Category Screen!'),
      ),
    );
    
  }

}
```

![Image](17.png)