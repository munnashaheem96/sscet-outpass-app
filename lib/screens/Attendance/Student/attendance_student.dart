import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceStudent extends StatefulWidget {
  final String studentRollNo;

  AttendanceStudent({required this.studentRollNo});

  @override
  _AttendanceStudentState createState() => _AttendanceStudentState();
}

class _AttendanceStudentState extends State<AttendanceStudent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, String> _attendanceRecords = {};
  int totalDays = 0;
  int totalPresentDays = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('attendance').doc(widget.studentRollNo).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final attendanceMap = Map<String, String>.from(data['attendance']);
        totalDays = data['totalDays'];
        totalPresentDays = data['totalPresentDays'];

        setState(() {
          _attendanceRecords = attendanceMap.map((key, value) {
            final date = DateTime.parse(key);
            return MapEntry(date, value);
          });
        });
      }
    } catch (e) {
      print('Error fetching attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendancePercentage =
        totalDays == 0 ? 0 : (totalPresentDays / totalDays * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) =>
                _attendanceRecords.containsKey(day) ? [_attendanceRecords[day]!] : [],
          ),
          SizedBox(height: 16),
          Text(
            'Total Attendance: $attendancePercentage%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
