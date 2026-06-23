```
https://pub.dev/packages/bluetooth_thermal_printer/install
```

`AndroidManifest.xml`
```
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />

<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
```

`lib/services/PrinterService.dart`

```dart
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:intl/intl.dart';

class PrinterService {

  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<List<BluetoothDevice>> getDevices() async {
    return await bluetooth.getBondedDevices();
  }

  Future<void> connect(BluetoothDevice device) async {
    if (!(await bluetooth.isConnected)!) {
      await bluetooth.connect(device);
    }
  }

  Future<void> disconnect() async {
    if ((await bluetooth.isConnected)!) {
      await bluetooth.disconnect();
    }
  }

  Future<void> testPrint() async {
    final bool? connected = await bluetooth.isConnected;
    if (connected == null || !connected) {
      throw Exception('Printer not connected');
    }

    final String now = DateFormat('dd/MM/yyyy | hh:mm a').format(DateTime.now());

    bluetooth.printNewLine();
    bluetooth.printCustom('TEST PRINT SUCCESSFUL', 2, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('Thank you for using our app!', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('Date: $now', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('--------------------------------', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }
}
```
