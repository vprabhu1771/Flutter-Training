```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SimInfo>? _simInfo;
  final _simCardInfoPlugin = SimCardInfo();
  bool isSupported = true;
  String? _selectedSimNumber;
  String? _selectedSimName;

  @override
  void initState() {
    super.initState();
    initSimInfoState();
  }

  // Request All Required Permissions
  Future<void> initSimInfoState() async {
    // Request multiple permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.sms,
    ].request();

    // Check if permissions are granted
    if (await Permission.phone.isGranted && await Permission.sms.isGranted) {
      try {
        List<SimInfo>? simCardInfo = await _simCardInfoPlugin.getSimInfo() ?? [];
        setState(() {
          _simInfo = simCardInfo;
        });
      } catch (e) {
        print('Error getting SIM info: $e');
      }
    } else {
      print('Permissions not granted');
    }
  }

  void _showSimSelectionDialog() {
    if (_simInfo == null || _simInfo!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No SIM cards found')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select SIM Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _simInfo!.map((sim) {
              final isSelected = _selectedSimNumber == sim.number;
              return RadioListTile<String>(
                title: Text(sim.carrierName ?? 'SIM ${sim.slotIndex + 1.toString()}'),
                subtitle: Text(sim.number ?? 'No number'),
                value: sim.number,
                groupValue: _selectedSimNumber,
                onChanged: (String? value) {
                  setState(() {
                    _selectedSimNumber = value;
                    _selectedSimName = sim.carrierName;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SIM Info'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (!isSupported) {
      return const Center(
        child: Text('SIM Info not supported'),
      );
    }
    if (_simInfo == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field with focus listener
          Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                _showSimSelectionDialog();
              }
            },
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Select SIM',
                hintText: 'Tap to select SIM',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.sim_card),
                suffixIcon: _selectedSimNumber != null
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedSimNumber = null;
                      _selectedSimName = null;
                    });
                  },
                )
                    : null,
              ),
              readOnly: true,
              controller: TextEditingController(
                text: _selectedSimName != null
                    ? '$_selectedSimName (${_selectedSimNumber ?? "No number"})'
                    : '',
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Display selected SIM info
          if (_selectedSimNumber != null)
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected SIM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Name: $_selectedSimName'),
                    Text('Number: $_selectedSimNumber'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Original SIM list (optional - keep for reference)
          Expanded(
            child: ListView.builder(
              itemCount: _simInfo?.length ?? 0,
              itemBuilder: (context, index) {
                final simInfo = _simInfo![index];
                return Card(
                  child: ListTile(
                    leading: Radio(
                      value: simInfo.number,
                      groupValue: _selectedSimNumber,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedSimNumber = value;
                          _selectedSimName = simInfo.carrierName ?? 'Unknown';
                        });
                      },
                    ),
                    title: Text('SIM ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Carrier Name: ${simInfo.carrierName}'),
                        Text('Display Name: ${simInfo.displayName}'),
                        Text('Slot Index: ${simInfo.slotIndex}'),
                        Text('Number: ${simInfo.number}'),
                        Text('Country ISO: ${simInfo.countryIso}'),
                        Text('Country Phone Prefix: ${simInfo.countryPhonePrefix}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```
