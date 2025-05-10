import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safehaven/components/button_style_custom.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/components/custom_checkbox.dart';
import 'package:safehaven/components/mytextfield_custom.dart';
import 'package:safehaven/components/password_textfield.dart';
import 'package:safehaven/components/smalltile_custom.dart';
import 'package:safehaven/pages/clogin_page.dart';
import 'package:safehaven/pages/logic/splash_screen_to.dart';
import 'package:safehaven/pages/logic/welcome_splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//new

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool termsandcond = true;

  void userRegister(
    ////// normal reg
    String name,
    String email,
    String pwd,
    String confirmPwd,
    bool termsCnd,
  ) async {
    // Check Terms & Conditions
    if (!termsCnd) {
      showErrormsg("Please accept the Terms and Conditions");
      return;
    }

    if (pwd != confirmPwd) {
      showErrormsg("Passwords don't match");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);

      String uid = userCredential.user!.uid;

////////// store reg user datas online /////////////////////

      // ✅ Save user info to Firestore
      //await FirebaseFirestore.instance.collection("users").doc(uid).set({
      //"name": name,
      //"email": email,
      //"uid": uid,
      //"createdAt": FieldValue.serverTimestamp(),
      //});

      //offline Save,
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_name', name);
      prefs.setString('user_email', email);

      Navigator.of(context, rootNavigator: true).pop();

      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        print(
            "✅ User registered and stored successfully. Navigating to splash screen...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeSplashscreen(),
          ),
        );
        print("✅ Navigation triggered.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      String message = "Signup failed. Try again.";
      if (e.code == 'email-already-in-use') {
        message = "Email is already in use.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address.";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak.";
      }

      print("❌ FirebaseAuthException: ${e.code}");
      showErrormsg(message);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("❌ Unexpected error: $e");
      showErrormsg("An unexpected error occurred: ${e.toString()}");
    }
  }

  void showErrormsg(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.grey.shade100,
          title: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out any previous session to force account picker
      await googleSignIn.signOut();

      // Now trigger sign-in and force account selection
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.pop(context); // Close loading
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String uid = userCredential.user!.uid;
      String? name = userCredential.user!.displayName ?? 'No Name';
      String? email = userCredential.user!.email ?? 'No Email';

      // 🔐 Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);

      // 🔍 Check if user is already registered
      // final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
      // final doc = await docRef.get();

      // if (!doc.exists) {
      //   await docRef.set({
      //     'name': name ?? 'No Name',
      //     'email': email ?? 'No Email',
      //     'uid': uid,
      //     'registeredAt': FieldValue.serverTimestamp(),
      //   });
      // }

      Navigator.pop(context); // Close loading
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeSplashscreen(),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading
      showErrormsg("Failed to sign in with Google");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: bkgndcolor_grad),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Icon(
                        Icons.account_circle,
                        size: 85,
                        color: Colors.grey.shade300,
                      ),
                      Text(
                        "Create your Account",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      MytextfieldCustom(
                        controller: usernameController,
                        labelText: "Username",
                        obscureText: false,
                        validator: (username) {
                          if (username == null || username.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        iconch: Icon(
                          Icons.account_box_outlined,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 13),
                      MytextfieldCustom(
                        controller: emailController,
                        labelText: "Email",
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(email)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        obscureText: false,
                        iconch: Icon(
                          Icons.email_outlined,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: PasswordField(
                          pswdcontroller: passwordController,
                          labeltext: 'Password',
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Please enter a password';
                            } else if (password.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: PasswordField(
                          pswdcontroller: confirmpasswordController,
                          labeltext: 'Confirm Password',
                          validator: (confirmPassword) {
                            if (confirmPassword == null ||
                                confirmPassword.isEmpty) {
                              return 'Please confirm your password';
                            } else if (confirmPassword !=
                                passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              valuee: termsandcond,
                              activecolor: auxColor2,
                              onChanged: (val) {
                                setState(() {
                                  termsandcond = val!;
                                });
                              },
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "I Agree to the  ",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13.2),
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                      color: auxColor2,
                                      fontSize: 13.2,
                                      decoration: TextDecoration.underline,
                                      decorationColor: mainColor,
                                      decorationThickness: 2.0),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ButtonStyleCustom(
                        textid: "Sign Up",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            userRegister(
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                              confirmpasswordController.text,
                              termsandcond,
                            );
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                        buttoncolor: Colors.blueGrey[900],
                        textcolor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey.shade800)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or Continue with',
                                style: TextStyle(color: Colors.grey.shade900),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                  thickness: 0.5, color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => signInWithGoogle(context),
                            child:
                                SmalltileCustom(imgPath: "assets/google.png"),
                          ),
                          const SizedBox(width: 12),
                          SmalltileCustom(imgPath: "assets/appleios.png")
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already a member?"),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SplashScreenTo(
                                    screen: LoginPage(),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Login',
                                style: TextStyle(
                                    color: auxColor,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: bottomsheetbkgndcolor,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Have an Account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.6,
                  ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  child: const Text("Login",
                      style: TextStyle(
                          color: auxColor,
                          fontSize: 15.6,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashScreenTo(
                          screen: LoginPage(),
                        ),
                      ),
                    );
                  },
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
