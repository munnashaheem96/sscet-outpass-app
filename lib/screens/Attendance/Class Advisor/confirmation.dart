import 'package:flutter/material.dart';

class AttendanceConfirmationPage extends StatelessWidget {
  final List<Map<String, dynamic>> absentStudents;
  final Function onConfirm;

  AttendanceConfirmationPage({
    required this.absentStudents,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 65, 65),
      appBar: AppBar(
        title: Text(
          'Confirm Absence',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 65, 65, 65),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: absentStudents.length,
              itemBuilder: (context, index) {
                final student = absentStudents[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),)
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      student['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'SIN: ${student['sin']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Confirm and Save'),
            ),
          ),
        ],
      ),
    );
  }
}