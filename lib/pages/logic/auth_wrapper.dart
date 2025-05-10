import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safehaven/pages/dhome_page.dart';
import 'package:safehaven/pages/bintro_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // ✅ User is signed in
          return const HomePage(); // use your actual home widget
        } else {
          // 🚪 User is not signed in
          return const IntroPage(); // use your actual login widget
        }
      },
    );
  }
}
