Here is a complete, minimal example of a **Taxi Booking** architecture using a **Node.js** backend with `socket.io` and a **Flutter** frontend with `socket_io_client`.

---

## 1. Node.js Backend Server

Create a new directory, run `npm init -y`, and install the required dependencies:

```bash
npm install express socket.io dotenv
```

`.env`
```env
PORT=3000
HOST=192.168.1.211
```

### `server.js`

```javascript
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

require('dotenv').config();

const port = process.env.PORT || 3000;
const host = process.env.HOST || '0.0.0.0';

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*" } // For development testing
});

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.id}`);

  // 1. Listen for ride requests from the passenger
  socket.on('request_ride', (bookingData) => {
    console.log('Ride requested:', bookingData);

    // Mock processing: Simulate a driver accepting after 2 seconds
    setTimeout(() => {
      const responseData = {
        bookingId: bookingData.bookingId,
        driverName: 'John Doe',
        vehicle: 'Toyota Prius (XYZ-1234)',
        driverLat: 40.7128,
        driverLng: -74.0060
      };
      
      // Send acceptance event back to this specific passenger
      socket.emit('ride_accepted', responseData);
      console.log('Ride accepted and sent to passenger.');

      // 2. Simulate real-time driver location updates every 3 seconds
      let step = 0;
      const intervalId = setInterval(() => {
        step += 1;
        if (step > 3) {
          clearInterval(intervalId); // Stop simulating after 3 updates
          return;
        }

        const locationUpdate = {
          bookingId: bookingData.bookingId,
          // Slightly move the coordinates closer
          currentLat: 40.7128 + (step * 0.001), 
          currentLng: -74.0060 + (step * 0.001),
        };

        socket.emit('driver_location_update', locationUpdate);
        console.log(`Sent driver location update step ${step}`);
      }, 3000);

    }, 2000);
  });

  socket.on('disconnect', () => {
    console.log(`User disconnected: ${socket.id}`);
  });
});

const PORT = 3000;
server.listen(PORT, () => {
  //   console.log(`Taxi server running on port ${PORT}`);
  console.log(`Server is running on http://${host}:${port}`);
});

```

Run the server using `node server.js`.

```
Server is running on http://192.168.1.211:3000
User connected: eA7YS0VVrm894QMbAAAB
Ride requested: {
  bookingId: 'XYZ-998877',
  passengerName: 'Alex',
  pickup: 'Central Park',
  dropoff: 'Times Square'
}
Ride accepted and sent to passenger.
Sent driver location update step 1
Sent driver location update step 2
Sent driver location update step 3
User disconnected: eA7YS0VVrm894QMbAAAB
```

---

## 2. Flutter Mobile Frontend

Add the `socket_io_client` package to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  socket_io_client: ^3.1.2 # Or the latest stable version compatible with your setup

```

### `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaxiBookingScreen(),
    );
  }
}

class TaxiBookingScreen extends StatefulWidget {
  @override
  _TaxiBookingScreenState createState() => _TaxiBookingScreenState();
}

class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
  late IO.Socket socket;
  String statusMessage = "Press the button to book a ride";
  String driverDetails = "";
  String liveLocation = "";

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    // Replace with your machine's local IP address if running on a real physical device. 
    // 10.0.2.2 is used to point to localhost from the Android Emulator.
    socket = IO.io('http://10.0.2.2:3000', IO.OptionBuilder()
      .setTransports(['websocket']) // Required for Flutter/Dart
      .disableAutoConnect()        
      .build());

    socket.connect();

    socket.onConnect((_) {
      print('Connected to backend socket server');
    });

    // Listen for ride acceptance
    socket.on('ride_accepted', (data) {
      setState(() {
        statusMessage = "Driver Found!";
        driverDetails = "Driver: ${data['driverName']}\nVehicle: ${data['vehicle']}";
        liveLocation = "Initial Loc: ${data['driverLat']}, ${data['driverLng']}";
      });
    });

    // Listen for real-time driver movement updates
    socket.on('driver_location_update', (data) {
      setState(() {
        liveLocation = "Live Moving Loc: ${data['currentLat']}, ${data['currentLng']}";
      });
    });

    socket.onDisconnect((_) => print('Disconnected from socket server'));
  }

  void bookRide() {
    setState(() {
      statusMessage = "Searching for nearby drivers...";
      driverDetails = "";
      liveLocation = "";
    });

    // Emit the ride request payload
    socket.emit('request_ride', {
      'bookingId': 'XYZ-998877',
      'passengerName': 'Alex',
      'pickup': 'Central Park',
      'dropoff': 'Times Square'
    });
  }

  @override
  void dispose() {
    socket.dispose(); // Avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Taxi Booking')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(statusMessage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 10),
                    if (driverDetails.isNotEmpty) Text(driverDetails, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    if (liveLocation.isNotEmpty) Text(liveLocation, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: bookRide,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text('Book Taxi Now', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

```

---

### ⚠️ Localhost Connectivity Tips

* **Android Emulator:** Use `http://10.0.2.2:3000` as configured above.
* **iOS Simulator:** Use `http://localhost:3000`.
* **Physical Device:** Use your machine’s explicit local network IP (e.g., `http://192.168.1.5:3000`) and make sure both your phone and machine are on the exact same Wi-Fi connection. Remember to configure Android network security configs if hitting non-HTTPS URLs on newer Android versions.
