import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/color/Colors.dart';

class GradeAssignmentsScreen extends StatefulWidget {
  @override
  _GradeAssignmentsScreenState createState() => _GradeAssignmentsScreenState();
}

class _GradeAssignmentsScreenState extends State<GradeAssignmentsScreen> {
  String? _selectedYear;
  String? _selectedDepartment;
  String? _selectedAssignmentId; // To store the selected assignment ID
  List<Map<String, dynamic>> students = []; // List to store student data
  List<Map<String, dynamic>> assignments = []; // List to store available assignments
  Map<String, TextEditingController> marksControllers = {}; // Map to store marks for each student
  Map<String, bool> isGraded = {}; // Map to track if a student is already graded

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
          _selectedYear = doc.data()?['year'];
          _selectedDepartment = doc.data()?['department'];
        });
        await _fetchAssignments(); // Fetch assignments when user data is loaded
      }
    }
  }

  Future<void> _fetchAssignments() async {
    if (_selectedYear != null && _selectedDepartment != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('assignments')
          .where('year', isEqualTo: _selectedYear)
          .where('department', isEqualTo: _selectedDepartment)
          .get();

      setState(() {
        assignments = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'title': data['title'] ?? 'Untitled Assignment',
            'max_marks': data['max_marks'] ?? 100, // Default to 100 if not set
          };
        }).toList();
      });
    }
  }

  Future<void> _fetchStudents() async {
    if (_selectedYear != null && _selectedDepartment != null && _selectedAssignmentId != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('year', isEqualTo: _selectedYear)
          .where('department', isEqualTo: _selectedDepartment)
          .where('role', isEqualTo: 'Student') // Filter for students only
          .get();

      setState(() {
        students = querySnapshot.docs.map((doc) {
          final studentId = doc.id;
          final data = doc.data() as Map<String, dynamic>;
          final name = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}';

          // Check if the student has existing grades for the selected assignment
          _checkExistingGrade(studentId);

          return {
            'id': studentId,
            'name': name,
          };
        }).toList();
      });
    }
  }

  Future<void> _checkExistingGrade(String studentId) async {
    final gradeDoc = await FirebaseFirestore.instance
        .collection('assignments')
        .doc(_selectedAssignmentId)
        .collection('grades')
        .doc(studentId)
        .get();

    if (gradeDoc.exists) {
      final marks = gradeDoc.data()?['marks'] ?? 0;
      setState(() {
        isGraded[studentId] = true;
        marksControllers[studentId] = TextEditingController(text: marks.toString());
      });
    } else {
      setState(() {
        isGraded[studentId] = false;
        marksControllers[studentId] = TextEditingController();
      });
    }
  }

  Future<void> _saveMarks() async {
    if (_selectedAssignmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an assignment.')),
      );
      return;
    }

    try {
      for (var student in students) {
        final studentId = student['id'];
        final marksText = marksControllers[studentId]?.text ?? '';
        final marks = marksText.isNotEmpty ? int.tryParse(marksText) ?? 0 : 0;

        // Fetch max marks for validation
        final assignmentDoc = await FirebaseFirestore.instance
            .collection('assignments')
            .doc(_selectedAssignmentId)
            .get();
        final maxMarks = (assignmentDoc.data() as Map<String, dynamic>)['max_marks'] ?? 100;

        if (marks > maxMarks) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Marks for ${student['name']} exceed maximum marks ($maxMarks)')),
          );
          continue; // Skip this student if marks exceed max
        }

        // Only update marks if the student is not already graded
        if (!isGraded[studentId]!) {
          await FirebaseFirestore.instance
              .collection('assignments')
              .doc(_selectedAssignmentId)
              .collection('grades')
              .doc(studentId)
              .set({
            'studentId': studentId,
            'marks': marks,
            'timestamp': FieldValue.serverTimestamp(),
          });

          setState(() {
            isGraded[studentId] = true; // Mark as graded after saving
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marks saved successfully for ungraded students!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving marks: $e')),
      );
    }
  }

  @override
  void dispose() {
    marksControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        title: Text(
          'Grade Assignments',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _selectedYear == null || _selectedDepartment == null
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Assignment Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedAssignmentId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      labelText: 'Select Assignment',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    items: assignments.map((assignment) {
                      return DropdownMenuItem<String>(
                        value: assignment['id'],
                        child: Text(
                          assignment['title'],
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAssignmentId = value;
                        // Clear previous data when changing assignment
                        students.clear();
                        marksControllers.clear();
                        isGraded.clear();
                        _fetchStudents(); // Fetch students and their grades for the new assignment
                      });
                    },
                    hint: Text('Select an assignment', style: TextStyle(color: Colors.grey[600])),
                  ),
                  SizedBox(height: 16),
                  if (_selectedAssignmentId != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final studentId = student['id'];
                          final isStudentGraded = isGraded[studentId] ?? false;

                          return Card(
                            color: AppColors.color3,
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                student['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: marksControllers[studentId],
                                  keyboardType: TextInputType.number,
                                  readOnly: isStudentGraded, // Make read-only if already graded
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[400]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: AppColors.primaryColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[400]!),
                                    ),
                                    hintText: isStudentGraded ? 'Graded' : 'Enter marks',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (_selectedAssignmentId != null) SizedBox(height: 16),
                  if (_selectedAssignmentId != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveMarks,
                      child: Text("Save Marks", style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ),
    );
  }
}