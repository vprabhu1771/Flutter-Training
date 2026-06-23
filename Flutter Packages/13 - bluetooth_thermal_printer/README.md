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

`lib/screens/HomeScreen.dart`

```dart
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

import '../services/PrinterService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrinterService printerService = PrinterService();

  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      final pairedDevices = await printerService.getDevices();

      setState(() {
        devices = pairedDevices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _connectPrinter(BluetoothDevice device) async {
    try {
      await printerService.connect(device);

      setState(() {
        connectedDevice = device;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${device.name} connected')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e')),
      );
    }
  }

  Future<void> _disconnectPrinter() async {
    await printerService.disconnect();

    setState(() {
      connectedDevice = null;
    });
  }

  Future<void> _testPrint() async {
    await printerService.testPrint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Printers'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : devices.isEmpty
          ? const Center(
        child: Text(
          'No paired printers found.\nPair printer from Bluetooth Settings.',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];

          final isConnected =
              connectedDevice?.address == device.address;

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.print),
              title: Text(device.name ?? "Unknown Printer"),
              subtitle: Text(device.address ?? ""),
              trailing: ElevatedButton(
                onPressed: () async {
                  if (isConnected) {
                    await _disconnectPrinter();
                  } else {
                    await _connectPrinter(device);
                  }
                },
                child: Text(
                  isConnected ? "Disconnect" : "Connect",
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: connectedDevice == null
          ? null
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _testPrint,
              child: Text(
                'Test Print (${connectedDevice!.name})',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
