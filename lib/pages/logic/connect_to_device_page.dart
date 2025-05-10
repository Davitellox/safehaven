import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

class ConnectToDevicePage extends StatefulWidget {
  const ConnectToDevicePage({super.key});

  @override
  State<ConnectToDevicePage> createState() => _ConnectToDevicePageState();
}

class _ConnectToDevicePageState extends State<ConnectToDevicePage> {
  bool isConnecting = false;
  String connectionStatus = "Not connected";

  void connectToDevice() async {
    setState(() {
      isConnecting = true;
      connectionStatus = "Checking Wi-Fi...";
    });

    final isWifiEnabled = await WiFiForIoTPlugin.isEnabled();

    if (!isWifiEnabled) {
      setState(() {
        isConnecting = false;
        connectionStatus = "⚠️ Wi-Fi is turned off!";
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Wi-Fi Required"),
          content: const Text(
            "Please enable Wi-Fi to connect to the SafeHaven device.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await WiFiForIoTPlugin.setEnabled(true,
                    shouldOpenSettings: true);
              },
              child: const Text("Enable Wi-Fi"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      connectionStatus = "Connecting...";
    });

    try {
      final response =
          await http.get(Uri.parse('http://192.168.4.1/ping')).timeout(
                const Duration(seconds: 5),
                onTimeout: () => throw Exception("Timeout"),
              );

      if (response.statusCode == 200 && response.body.contains("pong")) {
        setState(() {
          isConnecting = false;
          connectionStatus = "✅ Connected to SafeHaven Device!";
        });
      } else {
        setState(() {
          isConnecting = false;
          connectionStatus = "❌ Failed to connect (no pong)";
        });
      }
    } catch (e) {
      setState(() {
        isConnecting = false;
        connectionStatus = "❌ Failed to connect: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Connect to SafeHaven Device'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 100, color: Colors.blue[700]),
            const SizedBox(height: 20),
            Text(
              connectionStatus,
              style: TextStyle(
                fontSize: 18,
                color: isConnecting ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: isConnecting ? null : connectToDevice,
              icon: const Icon(
                Icons.sync,
                color: Colors.amber,
              ),
              label: Text(isConnecting ? "Connecting..." : "Connect Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Make sure your phone is connected to the device's Wi-Fi network",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
