import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewRegStudents extends StatefulWidget {
  const ViewRegStudents({super.key});

  @override
  _ViewRegStudentsState createState() => _ViewRegStudentsState();
}

class _ViewRegStudentsState extends State<ViewRegStudents> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userId = currentUser.uid;
    final box = await Hive.openBox('studentsBox');
    final List<dynamic> localStudents = box.get(userId, defaultValue: []);

    final List<Map<String, dynamic>> loadedStudents = localStudents
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();

    setState(() {
      students = loadedStudents;
      filteredStudents = students;
    });
  }

  void _filterStudents(String query) {
    setState(() {
      filteredStudents = students
          .where((student) => student["name"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _confirmDeleteStudent(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteStudent(student);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStudent(Map<String, dynamic> student) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userId = currentUser.uid;
    final box = await Hive.openBox('studentsBox');
    final List<dynamic> localStudents = box.get(userId, defaultValue: []);

    localStudents.removeWhere((s) =>
        s['name'] == student['name'] &&
        s['class'] == student['class'] &&
        (s['parentPhone'] == student['parentPhone'] ||
            s['parentNumber'] == student['parentNumber']));

    await box.put(userId, localStudents);

    _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Students"),
        backgroundColor: const Color.fromARGB(255, 165, 201, 213),
      ),
      body: Stack(
        children: [
          Container(decoration: bkgndcolor_grad),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  onChanged: _filterStudents,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columnSpacing: 20,
                              border: TableBorder.all(color: Colors.white),
                              columns: const [
                                DataColumn(
                                    label: Text("NAME",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("CLASS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("PARENT'S NUMBER",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text("ACTIONS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: filteredStudents.map((student) {
                                return DataRow(cells: [
                                  DataCell(Text(student["name"] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(Text(student["class"] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(Text(
                                      student["parentPhone"] ??
                                          student["parentNumber"] ??
                                          '',
                                      style: const TextStyle(
                                          color: Colors.white))),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          // TODO: Implement edit functionality
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _confirmDeleteStudent(student);
                                        },
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
