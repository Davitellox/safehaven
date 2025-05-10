import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/pages/bintro_screen.dart';
import 'package:safehaven/pages/logic/register_newstudents_screen.dart';
import 'package:safehaven/pages/logic/view_reg_students.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final bool _isMorning = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "";
  String userEmail = "";
  // bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // call on widget load
    // _connectDevicePrompt();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "No Name";
      userEmail = prefs.getString('user_email') ?? "No Email";
    });

    // if (Theme.of(context).platform == TargetPlatform.iOS ||
    //     Theme.of(context).platform == TargetPlatform.android) {
    //   // Show the prompt to register the device
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text("Connect to Device"),
    //         content: const Text("Please Connnect your device via WiFi"),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop(); // Close the dialog]
    //               Navigator.pushReplacement(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => const SignupPage(),
    //                 ),
    //               );
    //             },
    //             child: const Text("OK"),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut(); // Ensure Google session is cleared
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.all(.0),
          child: Stack(
            children: [
              Container(
                decoration: bkgndcolor_grad,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Account Balance and Eye Icon
                        Container(
                          width: 250,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(36, 158, 158, 158),
                            borderRadius:
                                BorderRadius.circular(20), // Curved edges
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isMorning ? "Welcome to School" : "Goodbye!",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Round User Image
                        GestureDetector(
                          onTap: () {
                            // Handle profile image click here // open navigation rail
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: const CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage("assets/icon/user.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Divider(thickness: 0.5, color: Colors.grey.shade800),
                  ),
                  const SizedBox(
                    height: 5.5,
                  ),
                  Center(
                    child: Column(
                      ///////////////////////// Register new students and view reg students ////////////////////////////////////////////////////////
                      ///
                      children: [
                        Container(
                          width: 320,
                          height: 260,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(36, 158, 158, 158),
                            borderRadius:
                                BorderRadius.circular(20), // Curved edges
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 25,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 2.5),
                                    ElevatedButton(
                                      /////////////////////////////// New Student registration
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterStudentScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(
                                            1.0), // Remove padding if necessary
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        elevation: 5,
                                      ),
                                      child: Image.asset(
                                          'assets/img/register_students.png', // Path to your img in assets
                                          width: 120, // Adjust size as needed
                                          height: 150,
                                          // width: screenwidth* 0.578,
                                          // height: screenHeight* 0.26,
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(
                                      height: 8.6,
                                    ),
                                    Center(
                                      child: Text(
                                        "Register New\n Student",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    ElevatedButton(
                                      ///////////////////////// View Registered students
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewRegStudents()),
                                        );

                                        // _viewStudentsDialog(
                                        //     context,
                                        //     "Dispose General Waste",
                                        //     "Dispose waste generally without sorting them");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(
                                            1.0), // Remove padding if necessary
                                        // backgroundColor: Colors.transparent,
                                        // shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        elevation: 5,
                                      ),
                                      child: Image.asset(
                                          'assets/img/view_students.png', // Path to your img in assets
                                          width: 120, // Adjust size as needed
                                          height: 150,
                                          // width: screenwidth* 0.578,
                                          // height: screenHeight* 0.26,
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "View Students",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 18.5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.5,
                        ),

                        ////////////////////////////////////////////////////////////////////////////

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Divider(
                              thickness: 0.5, color: Colors.grey.shade800),
                        ),
                        const SizedBox(
                          height: 9.5,
                        ),

                        Container(
                          ////
                          width: 330,
                          height: 230,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(36, 158, 158, 158),
                            borderRadius:
                                BorderRadius.circular(20), // Curved edges
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 35.5),

                                /////////////////////////////////////////////////////////////////////////////
                                /////////////////////////////////////////////////////////////////////////////
                                GestureDetector(
                                  onTap: () {}, // finger print funct
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(
                                          1.0), // Remove padding if necessary
                                      backgroundColor: Colors.transparent,

                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                    child: Image.asset(
                                        'assets/img/fingerprint.png', // Path to your img in assets
                                        width: 65, // Adjust size as needed
                                        height: 65,
                                        // width: screenwidth* 0.578,
                                        // height: screenHeight* 0.26,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () {},

                                  ///finger print functt
                                  child: Text(
                                    "Click to Verify student's Fingerprint",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.5,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(
                                        1.0), // Remove padding if necessary
                                    backgroundColor: Colors.lightBlue,

                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    "      Verify Fingerprint      ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/icon/user.png"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit Account"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Upgrade to Premium"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Contact Help"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => IntroPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
