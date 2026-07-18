Dismiss the on screen keyboard
```
https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard
```

```
import 'package:flutter/services.dart';

SystemChannels.textInput.invokeMethod('TextInput.hide');
```
