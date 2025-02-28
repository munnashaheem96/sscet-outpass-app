import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/assignments/full_screen_image.dart';
import 'package:first_app/color/Colors.dart';

class ViewAssignmentsScreen extends StatelessWidget {
  const ViewAssignmentsScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserDetails(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.color5));
          }

          if (userSnapshot.hasError || userSnapshot.data == null) {
            return Center(
              child: Text(
                'Error loading user details.',
                style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
              ),
            );
          }

          final userData = userSnapshot.data!;
          final String year = userData['year'];
          final String department = userData['department'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('assignments')
                .where('year', isEqualTo: year)
                .where('department', isEqualTo: department)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: AppColors.color5));
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No assignments available.',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
                  ),
                );
              }

              final assignments = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignmentData = assignments[index].data() as Map<String, dynamic>;
                  return AssignmentCard(assignmentData: assignmentData);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final Map<String, dynamic> assignmentData;

  const AssignmentCard({Key? key, required this.assignmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = assignmentData['title'] ?? 'No Title';
    final String lastDate = assignmentData['last_date'] ?? 'N/A';
    final String description = assignmentData['description'] ?? 'No description provided';
    final String? fileUrl = assignmentData['file_url'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.color3,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fileUrl != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullScreenImage(imageUrl: fileUrl)),
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  fileUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)),
                const SizedBox(height: 8),
                Text("Last Date: $lastDate",
                    style: TextStyle(fontSize: 14, color: AppColors.secondaryColor)),
                const SizedBox(height: 8),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}