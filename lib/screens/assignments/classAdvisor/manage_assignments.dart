import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/color/Colors.dart';

class ManageAssignmentsScreen extends StatefulWidget {
  @override
  _ManageAssignmentsScreenState createState() => _ManageAssignmentsScreenState();
}

class _ManageAssignmentsScreenState extends State<ManageAssignmentsScreen> {
  String? _selectedYear;
  String? _selectedDepartment;

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
      }
    }
  }

  Future<void> _deleteAssignment(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('assignments').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assignment deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting assignment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        title: Text(
          'Manage Assignments',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _selectedYear == null || _selectedDepartment == null
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('assignments')
                  .where('year', isEqualTo: _selectedYear)
                  .where('department', isEqualTo: _selectedDepartment)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading assignments.',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No assignments found.',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                    ),
                  );
                }

                final assignments = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index].data() as Map<String, dynamic>;
                    final docId = assignments[index].id;

                    return Card(
                      color: AppColors.color3,
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          assignment['title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Last Date: ${assignment['last_date'] ?? 'N/A'}',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              assignment['description'] ?? 'No description',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Assignment'),
                                content: Text('Are you sure you want to delete this assignment?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteAssignment(docId);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}