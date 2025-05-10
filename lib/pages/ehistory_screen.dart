import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safehaven/components/color.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Attendance History"),
        backgroundColor: Color.fromARGB(255, 165, 201, 213),
      ),
      body: Stack(children: [
        Container(decoration: bkgndcolor_grad,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text("Choose Specific Date"),
                  ),
                  SizedBox(width: 45),
                  Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Student Name",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        border: TableBorder.all(color: Colors.white),
                        columns: [
                          DataColumn(
                            label: Expanded(
                              child: Text("NAME",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                          DataColumn(
                            label: Text("CLASS",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
                          ),
                          DataColumn(
                            label: Text("SIGN IN",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          ),
                          DataColumn(
                            label: Text("SIGN OUT",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ),
                        ],
                        rows: List.generate(
                          20,
                          (index) {
                            String studentName = "Student $index";
                            String studentClass = "Class ${(index % 5) + 1}";
                            if (searchQuery.isNotEmpty &&
                                !studentName.toLowerCase().contains(searchQuery)) {
                              return null;
                            }
                            return DataRow(cells: [
                              DataCell(SizedBox(
                                width: 80,
                                child: Text(studentName, style: TextStyle(color: Colors.white),),
                              )),
                              DataCell(Text(studentClass, style: TextStyle(color: Colors.white),)),
                              DataCell(Text("08:00 AM", style: TextStyle(color: Colors.white),)),
                              DataCell(Text("02:00 PM", style: TextStyle(color: Colors.white),)),
                            ]);
                          },
                        ).whereType<DataRow>().toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
