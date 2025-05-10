// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safehaven/components/button_style_custom.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/components/custom_checkbox.dart';
import 'package:safehaven/components/password_textfield.dart';
import 'package:safehaven/components/smalltile_custom.dart';
import 'package:safehaven/components/textformfield_custom.dart';
import 'package:safehaven/pages/bintro_screen.dart';
import 'package:safehaven/pages/logic/splash_screen_to.dart';
import 'package:safehaven/pages/logic/welcome_back_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  // var passicon = const Icon(Icons.visibility);
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text Controller
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool rememberpass = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade100,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        });
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }

    // Allow letters, numbers, spaces, and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_ ]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers, spaces, and underscores allowed';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    const emailRegex = r'^[^@]+@[^@]+\.[^@]+$';
    if (!RegExp(emailRegex).hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // If you want to force account selection, uncomment this line:
      await googleSignIn.signOut();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.pop(context);
        return;
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
      String name = userCredential.user!.displayName ?? "User";
      String email = userCredential.user!.email ?? "Email not found";

      //save Locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);

      // ✅ OPTIONAL: Check if user already exists in Firestore
      // If you're using Firestore to store registered users:
      //final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
      //final doc = await docRef.get();

      //if (!doc.exists) {
      //Navigator.pop(context);
      //showErrorMessage("This Google account is not registered.");
      //return;
      //}

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeBackUser(),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showErrorMessage("Failed to Login with Google");
    }
  }

  void userLogin() async {
    if (_formKey.currentState!.validate()) {
      // Show loading spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );

      try {
        // Attempt Firebase login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // 🔐 Save locally
        final prefs = await SharedPreferences.getInstance();
        String name = nameController.text.trim();
        String email = emailController.text.trim();

        // Overwrite in case login is from new school
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', name);

        // Hide loading spinner
        Navigator.pop(context);

        // Navigate to welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeBackUser()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Close loading
        String errorMsg;
        switch (e.code) {
          case 'user-not-found':
            errorMsg = "No user found for that email.";
            break;
          case 'wrong-password':
            errorMsg = "Incorrect password.";
            break;
          case 'invalid-email':
            errorMsg = "Invalid email address.";
            break;
          default:
            errorMsg = "Login failed. Try again";
        }
        showErrorMessage(errorMsg);
      }
    }
  }

  // //show error message to User

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // bottomSheet:
        body: Stack(
          children: [
            Container(
              decoration: bkgndcolor_grad,
            ),
            Form(
              key: _formKey,
              child: SafeArea(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      /// 50
                      Icon(
                        Icons.lock,
                        size: 50,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      //logo

                      Text(
                        "Welcome Back you've been missed!",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),

                      //Text Welcome,
                      const SizedBox(
                        height: 25,
                      ),
                      TextformfieldCustom(
                        controller: nameController,
                        labelText: "UserName",
                        obscureText: false,
                        iconch: const Icon(Icons.person),
                        // iconcolor: Colors.black,
                        validator: _validateUsername,
                        keyboardtype: TextInputType.text,
                        padding_double: 25.0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextformfieldCustom(
                        controller: emailController,
                        labelText: "Email",
                        obscureText: false,
                        iconch: const Icon(Icons.email),
                        // iconcolor: Colors.black,
                        validator: _validateEmail,
                        keyboardtype: TextInputType.emailAddress,
                        padding_double: 25.0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PasswordField(
                            pswdcontroller: passwordController,
                            labeltext: 'Password',
                            color: Colors.grey[800],
                            validator: _validatePassword,
                          )),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomCheckbox(
                                  valuee: rememberpass,
                                  activecolor: auxColor2,
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            GestureDetector(
                              //forgot password fix
                              onTap: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: mainColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: mainColor,
                                    decorationThickness: 2.0),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      ButtonStyleCustom(
                        textid: "Login",
                        // onTap: userLogin, ///// welcome back user
                        onTap: () {
                          userLogin();
                        },
                        buttoncolor: Colors.blueGrey[900],
                        textcolor: Colors.white,
                      ),

                      const SizedBox(
                        height: 36,
                      ),

                      //goggle sign in
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey.shade700)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or Continue with',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                  thickness: 0.5, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      // Google sign in Button,
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await loginWithGoogle(context);
                            },
                            child:
                                SmalltileCustom(imgPath: "assets/google.png"),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            //Apple signIn
                            onTap: () {},
                            child:
                                SmalltileCustom(imgPath: "assets/appleios.png"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),

                      ////     NOT THISSSSS
                      //Not a member, sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have an Account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            /// to sign up page choose
                            onPressed: () {
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const SplashScreenTo(
                              //               screen: CategoryPage(),
                              //             )));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.black38)),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: auxColor, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ),
            // Show bottom sheet only when keyboard is not open
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: bottomsheetbkgndcolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have an Account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.6,
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: auxColor,
                            fontSize: 15.6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreenTo(
                                screen: IntroPage(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ));
  }
}
