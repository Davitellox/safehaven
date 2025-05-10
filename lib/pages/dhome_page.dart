import 'package:flutter/material.dart';
import 'package:safehaven/pages/ehistory_screen.dart';
import 'package:safehaven/pages/ehome_screen.dart';
import 'package:safehaven/pages/esettings_screen.dart';
import 'package:safehaven/pages/logic/connect_to_device_page.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const homescreen(), // main
    HistoryPage(), // history
    const settingscreen(), // settings
    ConnectToDevicePage(), // connect
  ];

  @override
  void initState() {
    super.initState();
    _tryAutoConnectToESP();
    // _syncLocalStudentsToFirebase();
  }

  void _tryAutoConnectToESP() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // ensure context is ready

    final isWifiEnabled = await WiFiForIoTPlugin.isEnabled();

    if (!isWifiEnabled) {
      _showConnectPrompt(
          "Wi-Fi is turned off. Please enable it to connect to SafeHaven device.");
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('http://192.168.4.1/ping')).timeout(
                const Duration(seconds: 5),
                onTimeout: () => throw Exception("Timeout"),
              );

      if (response.statusCode == 200 && response.body.contains("pong")) {
        debugPrint("✅ Auto-connected to SafeHaven device.");
      } else {
        _showConnectPrompt(
            "Could not reach the SafeHaven device. \nPlease connect manually via Wi-Fi\n for full functionality.");
      }
    } catch (e) {
      _showConnectPrompt("Connection failed: ${e.toString()}");
    }
  }

  void _showConnectPrompt(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connect to Device"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selectedIndex = 3; // Navigate to Connect tab
              });
            },
            child: const Text("Connect Now"),
          ),
        ],
      ),
    );
  }

  void _showWifiPromptOnce() {
    // Delay to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Connect to Device"),
          content: const Text(
              "Please connect your phone to SafeHaven device via Wi-Fi\n for full functionality."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 3; // Navigate to Connect page
                });
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Future<void> _syncLocalStudentsToFirebase() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final currentUser = FirebaseAuth.instance.currentUser;

  //   if (currentUser == null) {
  //     print("No user logged in. Skipping sync.");
  //     return;
  //   }

  //   final userId = currentUser.uid;
  //   final studentsJson = prefs.getString('students');

  //   if (studentsJson == null) {
  //     print("No local students found to sync.");
  //     return;
  //   }

  //   final List<dynamic> students = json.decode(studentsJson);
  //   final CollectionReference studentCollection = FirebaseFirestore.instance
  //       .collection("schools")
  //       .doc(userId)
  //       .collection("students");

  //   for (var student in students) {
  //     try {
  //       await studentCollection.add({
  //         'name': student['name'],
  //         'class': student['class'],
  //         'parentPhone': student['parentNumber'],
  //         'fingerprint': true,
  //         'createdAt': Timestamp.now(),
  //       });
  //     } catch (e) {
  //       print("Error uploading student: $e");
  //     }
  //   }

  //   // Clear local data after successful upload
  //   await prefs.remove('students');
  //   print("Synced and cleared local students.");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Offline students synced!")),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 165, 201, 213),
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 171, 166, 166),
        items: [
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedIndex == 0 ? 60 : 30,
              height: _selectedIndex == 0 ? 60 : 30,
              child: Image.asset('assets/icon/home.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedIndex == 1 ? 60 : 30,
              height: _selectedIndex == 1 ? 60 : 30,
              child: Image.asset('assets/icon/history.png'),
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedIndex == 2 ? 60 : 30,
              height: _selectedIndex == 2 ? 60 : 30,
              child: Image.asset('assets/icon/setting.png'),
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedIndex == 3 ? 60 : 30,
              height: _selectedIndex == 3 ? 60 : 30,
              child: Image.asset('assets/icon/connect.png'),
            ),
            label: 'Connect',
          ),
        ],
      ),
    );
  }
}
