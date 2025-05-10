import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/components/textformfield_custom.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safehaven/pages/csignup_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  _RegisterStudentScreenState createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _parentNumberController = TextEditingController();

  final List<String> _classOptions = [
    "Creche",
    "Pre-Nursery",
    "Nursery 1",
    "Nursery 2",
    "Nursery 3",
    "Nursery 4",
    "Primary 1",
    "Primary 2",
    "Primary 3",
    "Primary 4",
    "Primary 5",
    "Primary 6",
    "Jss1",
    "Jss2",
    "Jss3",
    "Ss1",
    "Ss2",
    "Ss3",
  ];

  String? _selectedClass;
  bool _authenticated = false;
  String? _phoneNumber;

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: "Scan student's fingerprint to register",
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: "Fingerprint Required",
            cancelButton: "Cancel",
            biometricHint: "Touch sensor",
            biometricNotRecognized: "Try again.",
            biometricSuccess: "Fingerprint recognized!",
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _authenticated = didAuthenticate;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(didAuthenticate
            ? "Fingerprint recognized!"
            : "Fingerprint not recognized."),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fingerprint is required")),
      );
      return;
    }

    final name = _nameController.text.trim();
    final studentClass = _selectedClass ?? "";
    // final parentNumber = _phoneNumber ?? _parentNumberController.text.trim();

    String rawPhone = _parentNumberController.text.trim();
    if (rawPhone.startsWith("0")) {
      rawPhone = "+234${rawPhone.substring(1)}";
    }
    final parentNumber = _phoneNumber ?? rawPhone;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are not Registered.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupPage(),
        ),
      );
      return;
    }

    final userId = currentUser.uid;

    final studentData = {
      'name': name,
      'class': studentClass,
      'parentPhone': parentNumber,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final box = await Hive.openBox('studentsBox');
    List students = box.get(userId, defaultValue: []);

    final existingStudent = students.any((student) =>
        student['name'].toString().toLowerCase() == name.toLowerCase() &&
        student['class'] == studentClass &&
        student['parentPhone'] == parentNumber);

    if (existingStudent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student already registered.")),
      );
      showErrorMessage("Student already registered.");
      return;
    }

    students.add(studentData);
    await box.put(userId, students);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Student registered!")),
    );
    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register New Student"),
        backgroundColor: Color.fromARGB(255, 165, 201, 213),
      ),
      body: Stack(
        children: [
          Container(decoration: bkgndcolor_grad),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(Icons.person_add_alt_1_outlined,
                      size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 50),
                  TextformfieldCustom(
                    controller: _nameController,
                    labelText: "Student's Name",
                    obscureText: false,
                    iconch: const Icon(Icons.donut_small_outlined),
                    prefix_icon: const Icon(
                      Icons.person_2_outlined,
                    ),
                    keyboardtype: TextInputType.text,
                    padding_double: 0.0,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? "Name required"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.school, color: Colors.grey.shade800),
                      labelText: 'Class',
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      filled: true,
                      fillColor: Colors.grey.shade400,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // dropdownColor: const Color.fromARGB(255, 19, 19, 19),
                    dropdownColor: Colors.grey.shade900,
                    iconEnabledColor: Colors.grey.shade800,
                    style: const TextStyle(color: Colors.white),
                    value: _selectedClass,
                    isExpanded: true,
                    items: _classOptions.map((String classOption) {
                      final bool isSelected = classOption == _selectedClass;
                      return DropdownMenuItem<String>(
                        value: classOption,
                        child: Text(
                          classOption,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.grey.shade800
                                : Colors.white,
                            // backgroundColor: isSelected ? Colors.black : null,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Class required'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextformfieldCustom(
                    controller: _parentNumberController,
                    labelText: "Parent's Phone Number",
                    obscureText: false,
                    iconch: const Icon(Icons.donut_small_outlined),
                    prefix_icon: const Icon(
                      Icons.phone,
                    ),
                    keyboardtype: TextInputType.phone,
                    padding_double: 0.0,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Phone number required";
                      }
                      final input = val.trim();
                      final pattern = r'^(?:\+234|0)\d{10}$';
                      final regex = RegExp(pattern);
                      if (!regex.hasMatch(input)) {
                        showErrorMessage(
                            "use- +234 or 0 followed by 10 digits");
                        return "Wrong phone number format";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _authenticate,
                    child: Column(
                      children: [
                        const Text("Register Student's Fingerprint",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.5)),
                        const SizedBox(height: 10),
                        Icon(
                          Icons.fingerprint,
                          size: 85,
                          color: _authenticated
                              ? Colors.green
                              : Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 201, 235, 162),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Register",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
