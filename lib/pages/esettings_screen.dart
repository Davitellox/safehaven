import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/pages/bintro_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class settingscreen extends StatelessWidget {
  const settingscreen({super.key});

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut(); // Ensure Google session is cleared
  }

  Future<void> _launchSafeHavenWebsite() async {
    final Uri url = Uri.parse(
        "https://www.alternative-energy-tutorials.com/biomass/waste-to-energy-conversion.html"); // Replace with your actual link
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Color.fromARGB(255, 165, 201, 213),
      ),
      body: Stack(
        children: [
          Container(decoration: bkgndcolor_grad),
          Column(
            children: [
              // Rectangular box with background image
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/bgimg/stbg.jpg"), // Add an image in assets
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        "assets/icon/user.png"), // User profile image
                  ),
                ),
              ),

              // List of settings options
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingsItem(
                      title: "Your Account",
                      icon: Icons.person,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "Upgrade to Premium",
                      color: Colors.orangeAccent,
                      icon: Icons.diamond,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "Contact & Help",
                      icon: Icons.help_outline,
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text(
                        "Visit our Website",
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: const Icon(Icons.public, color: Colors.green),
                      trailing: const Icon(Icons.open_in_new,
                          size: 18, color: Colors.grey),
                      onTap: _launchSafeHavenWebsite,
                    ),
                    _buildSettingsItem(
                      title: "Logout",
                      icon: Icons.exit_to_app,
                      onTap: () async {
                        await logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntroPage(),
                          ),
                        );
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Color.fromARGB(255, 165, 201, 213)),
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 18, color: color ?? const Color.fromARGB(255, 160, 160, 160)),
      onTap: onTap,
    );
  }
}
