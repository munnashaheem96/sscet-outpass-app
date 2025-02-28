import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'hod_re_details.dart';

class HODApprovalScreen extends StatelessWidget {
  final Map<String, String> departmentShortForms = {
    'Mechanical Engineering': 'ME',
    'Computer Science & Engineering': 'CSE',
    'Electronics & Communication': 'ECE',
    'Agriculture Engineering': 'AE',
    'Biomedical Engineering': 'BME',
    'Artificial Intelligence & Data Science': 'AIDS',
    'Information Technology': 'IT',
    'Computer Science Engineering - Cyber Security': 'CSE-CS',
    'Science & Humanities': 'S&H',
  };

  Future<Map<String, dynamic>> _fetchHodDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'HOD Approvals',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchHodDetails(),
        builder: (context, hodSnapshot) {
          if (!hodSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final hodData = hodSnapshot.data!;
          final hodDepartment = hodData['department'];

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('outpass_requests')
                .where('class_advisor_status', isEqualTo: 'Approved')
                .where('hod_status', isEqualTo: 'Pending')
                .where('department', isEqualTo: hodDepartment)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final outpasses = snapshot.data!.docs;

              if (outpasses.isEmpty) {
                return Center(child: Text('No pending requests'));
              }

              return ListView.builder(
                itemCount: outpasses.length,
                itemBuilder: (context, index) {
                  final outpass = outpasses[index].data();
                  final docId = outpasses[index].id;
                  final isHosteller = outpass['day_scholar_or_hosteller'] == 'Hosteller';
                  final departmentShortForm = departmentShortForms[outpass['department']] ?? outpass['department'];

                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(102, 73, 239, 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width - 16,
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Outpass ID: $docId${outpass['sin']}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Name: ${outpass['name']}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Year: ${outpass['year']}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Department: $departmentShortForm', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('SIN: ${outpass['sin']}', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Time: ${outpass['time']}', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 12,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Color.fromRGBO(102, 73, 239, 1)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HodRequestDetailsScreen(requestId: docId)),
                            );
                          },
                          child: Text('Review', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      if (isHosteller)
                        Positioned(
                          right: 16,
                          top: 16,
                          child: Opacity(
                            opacity: 0.2,
                            child: Text(
                              'H',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(102, 73, 239, 0.5),
                              ),
                            ),
                          ),
                        ),
                      if (!isHosteller)
                        Positioned(
                          right: 16,
                          top: 16,
                          child: Opacity(
                            opacity: 0.2,
                            child: Text(
                              'D',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(102, 73, 239, 0.5),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}