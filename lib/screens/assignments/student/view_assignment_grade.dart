import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/color/Colors.dart';

class ViewAssignmentGrade extends StatefulWidget {
  @override
  _ViewAssignmentGradeState createState() => _ViewAssignmentGradeState();
}

class _ViewAssignmentGradeState extends State<ViewAssignmentGrade> {
  String? _selectedYear;
  String? _selectedDepartment;
  String? _studentId;
  List<Map<String, dynamic>> assignmentsWithGrades = []; // List to store assignments and grades
  double? _averagePercentage; // To calculate average performance

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _studentId = user.uid;
          _selectedYear = doc.data()?['year'];
          _selectedDepartment = doc.data()?['department'];
        });
        await _fetchAssignmentsWithGrades();
      }
    }
  }

  Future<void> _fetchAssignmentsWithGrades() async {
    if (_studentId != null && _selectedYear != null && _selectedDepartment != null) {
      final assignmentsSnapshot = await FirebaseFirestore.instance
          .collection('assignments')
          .where('year', isEqualTo: _selectedYear)
          .where('department', isEqualTo: _selectedDepartment)
          .get();

      double totalPercentage = 0;
      int gradedCount = 0;

      for (var doc in assignmentsSnapshot.docs) {
        final assignmentId = doc.id;
        final assignmentData = doc.data() as Map<String, dynamic>;
        final maxMarks = assignmentData['max_marks'] ?? 100;
        final gradesSnapshot = await FirebaseFirestore.instance
            .collection('assignments')
            .doc(assignmentId)
            .collection('grades')
            .doc(_studentId)
            .get();

        final marks = gradesSnapshot.exists ? (gradesSnapshot.data()?['marks'] ?? 0) : 0;
        final isGraded = gradesSnapshot.exists;

        if (isGraded && maxMarks > 0) {
          final percentage = (marks / maxMarks) * 100;
          totalPercentage += percentage;
          gradedCount++;
        }

        setState(() {
          assignmentsWithGrades.add({
            'title': assignmentData['title'] ?? 'Untitled Assignment',
            'marks': marks,
            'max_marks': maxMarks,
            'isGraded': isGraded,
          });
        });
      }

      // Calculate average performance (percentage)
      if (gradedCount > 0) {
        setState(() {
          _averagePercentage = totalPercentage / gradedCount;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        title: Text(
          'My Assignment Grades',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _selectedYear == null || _selectedDepartment == null || _studentId == null
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Performance Summary
                  if (_averagePercentage != null)
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.color3,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Overall Performance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Average: ${_averagePercentage!.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  // Assignments List
                  Expanded(
                    child: assignmentsWithGrades.isEmpty
                        ? Center(
                            child: Text(
                              'No assignments or grades available.',
                              style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: assignmentsWithGrades.length,
                            itemBuilder: (context, index) {
                              final assignment = assignmentsWithGrades[index];
                              return Card(
                                color: AppColors.color3,
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.0),
                                  title: Text(
                                    assignment['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    assignment['isGraded']
                                        ? 'Marks: ${assignment['marks']} / ${assignment['max_marks']}'
                                        : 'Not graded yet',
                                    style: TextStyle(
                                      color: assignment['isGraded'] ? AppColors.secondaryColor : Colors.grey[600],
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
    );
  }
}