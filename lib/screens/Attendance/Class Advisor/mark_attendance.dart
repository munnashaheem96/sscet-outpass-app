import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkAttendance extends StatefulWidget {
  final String year;
  final String department;

  MarkAttendance({required this.year, required this.department});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> students = [];
  Map<String, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      // Fetch students from the `users` collection based on year and department.
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Student')
          .where('year', isEqualTo: widget.year)
          .where('department', isEqualTo: widget.department)
          .get();

      setState(() {
        students = querySnapshot.docs.map((doc) {
          return {'rollNo': doc.id, 'name': doc['firstName'] + ' ' + doc['lastName']};
        }).toList();

        // Initialize attendance map
        for (var student in students) {
          attendance[student['rollNo']] = false;
        }
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> _saveAttendance() async {
    try {
      final date = DateTime.now();
      final formattedDate = '${date.year}-${date.month}-${date.day}';

      for (var entry in attendance.entries) {
        final rollNo = entry.key;
        final isPresent = entry.value;

        DocumentReference studentDoc = _firestore.collection('attendance').doc(rollNo);

        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(studentDoc);

          if (!snapshot.exists) {
            // Create a new attendance record if it doesn't exist.
            transaction.set(studentDoc, {
              'rollNo': rollNo,
              'attendance': {formattedDate: isPresent ? 'Present' : 'Absent'},
              'totalPresentDays': isPresent ? 1 : 0,
              'totalDays': 1,
            });
          } else {
            // Update existing attendance record.
            final data = snapshot.data() as Map<String, dynamic>;
            final attendanceMap = Map<String, String>.from(data['attendance']);
            attendanceMap[formattedDate] = isPresent ? 'Present' : 'Absent';

            transaction.update(studentDoc, {
              'attendance': attendanceMap,
              'totalPresentDays': data['totalPresentDays'] + (isPresent ? 1 : 0),
              'totalDays': data['totalDays'] + 1,
            });
          }
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Attendance saved successfully!')));
    } catch (e) {
      print('Error saving attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving attendance: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance (${widget.year}, ${widget.department})'),
      ),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text(student['rollNo']),
                  trailing: Checkbox(
                    value: attendance[student['rollNo']],
                    onChanged: (bool? value) {
                      setState(() {
                        attendance[student['rollNo']] = value!;
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAttendance,
        child: Icon(Icons.save),
      ),
    );
  }
}
