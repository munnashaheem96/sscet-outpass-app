import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/Attendance/Class%20Advisor/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceMarkingPage extends StatefulWidget {
  @override
  _AttendanceMarkingPageState createState() => _AttendanceMarkingPageState();
}

class _AttendanceMarkingPageState extends State<AttendanceMarkingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _dayType; // 'Holiday' or 'Working Day'
  List<String> dayTypes = ['Working Day', 'Holiday'];
  String? _selectedDate;
  List<Map<String, dynamic>> _students = [];
  Map<String, bool> _attendanceStatus = {};
  bool _isFinalized = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('dd-mm-yyyy').format(DateTime.now());
    _fetchStudents();
  }

Future<void> _fetchStudents() async {
  final currentUser = _auth.currentUser;
  if (currentUser != null) {
    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final String? year = userData['year'];
    final String? department = userData['department'];

    if (year != null && department != null) {
      // Check if the day is a holiday
      final holidayDoc = await _firestore
          .collection('attendance')
          .doc('$year-$department')
          .collection(_selectedDate!)
          .doc('holiday')
          .get();

      if (holidayDoc.exists && holidayDoc.data()?['dayType'] == 'Holiday') {
        setState(() {
          _isFinalized = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Today is a holiday. Attendance is not required.')),
        );
        return;
      }

      // Check if attendance is already finalized
      final attendanceDoc = await _firestore
          .collection('attendance')
          .doc('$year-$department')
          .collection(_selectedDate!)
          .doc('finalized')
          .get();

      setState(() {
        _isFinalized = attendanceDoc.exists && attendanceDoc.data()?['finalized'] == true;
      });

      if (_isFinalized) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance is already finalized and cannot be edited.')),
        );
        return;
      }

      // Fetch students if attendance is not finalized
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('year', isEqualTo: year)
          .where('department', isEqualTo: department)
          .where('role', isEqualTo: 'Student')
          .get();

      setState(() {
        _students = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': '${data['firstName']} ${data['lastName']}',
            'sin': data['sin'],
          };
        }).toList();

        _attendanceStatus = {
          for (var student in _students) student['id']: false,
        };
      });
    }
  }
}

Future<void> _markAttendance() async {
  final currentUser = _auth.currentUser;
  if (currentUser != null) {
    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    final String? year = userData['year'];
    final String? department = userData['department'];

    if (year != null && department != null) {
      // If the day is a holiday, skip attendance marking
      if (_dayType == 'Holiday') {
        final batch = _firestore.batch();

        // Mark the day as a holiday
        final holidayRef = _firestore
            .collection('attendance')
            .doc('$year-$department')
            .collection(_selectedDate!)
            .doc('holiday');

        batch.set(holidayRef, {
          'dayType': 'Holiday',
          'date': _selectedDate,
          'finalized': true, // Mark as finalized
        });

        await batch.commit();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Day marked as a holiday!')),
        );
        return;
      }

      // If the day is a working day, proceed with attendance marking
      final absentStudents = _students
          .where((student) => !(_attendanceStatus[student['id']] ?? false))
          .toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceConfirmationPage(
            absentStudents: absentStudents,
            onConfirm: () async {
              final batch = _firestore.batch();

              for (var student in _students) {
                final studentId = student['id'];
                final isPresent = _attendanceStatus[studentId] ?? false;

                final attendanceRef = _firestore
                    .collection('attendance')
                    .doc('$year-$department')
                    .collection(_selectedDate!)
                    .doc(studentId);

                batch.set(attendanceRef, {
                  'studentId': studentId,
                  'name': student['name'],
                  'sin': student['sin'],
                  'isPresent': isPresent,
                  'date': _selectedDate,
                  'dayType': _dayType ?? 'Working Day', // Save day type
                  'finalized': true, // Mark attendance as finalized
                });
              }

              // Mark the attendance as finalized
              final finalizedRef = _firestore
                  .collection('attendance')
                  .doc('$year-$department')
                  .collection(_selectedDate!)
                  .doc('finalized');

              batch.set(finalizedRef, {'finalized': true});

              await batch.commit();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attendance marked successfully!')),
                );
              }
            },
          ),
        ),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 65, 65, 65),
    appBar: AppBar(
      title: Text(
        'Mark Attendance',
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Date: $_selectedDate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            value: _dayType ?? 'Working Day', // Default to 'Working Day'
            onChanged: _isFinalized
                ? null // Disable dropdown if attendance is finalized
                : (String? newValue) {
                    setState(() {
                      _dayType = newValue;
                    });
                  },
            items: dayTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Day Type',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              final studentId = student['id'];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: CheckboxListTile(
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
                  value: _attendanceStatus[studentId],
                  onChanged: _isFinalized
                      ? null // Disable checkbox if attendance is finalized
                      : (value) {
                          setState(() {
                            _attendanceStatus[studentId] = value ?? false;
                          });
                        },
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  tileColor: Colors.transparent,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isFinalized ? null : _markAttendance, // Disable button if finalized
            child: Text('Mark Attendance'),
          ),
        ),
      ],
    ),
  );
}
}