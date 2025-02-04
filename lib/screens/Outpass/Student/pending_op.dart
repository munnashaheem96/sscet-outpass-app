import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/Outpass/Student/check_op_status.dart';
import 'package:flutter/material.dart';

class PendingOutpassScreen extends StatelessWidget {
  // Mapping of department names to their short forms
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Outpasses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('outpass_requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending outpasses at the moment.'));
          }

          final outpasses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: outpasses.length,
            itemBuilder: (context, index) {
              final outpass = outpasses[index].data() as Map<String, dynamic>;
              final docId = outpasses[index].id; // Retrieve the document ID
              final isHosteller = outpass['day_scholar_or_hosteller'] == 'Hosteller';

              // Get the department short form
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
                        Text(
                          'Name: ${outpass['name']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Year: ${outpass['year']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Department: $departmentShortForm', // Use short form
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'SIN: ${outpass['sin']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Time: ${outpass['time']}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 12,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(102, 73, 239, 1)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context)=> CheckOpStatus(requestId: (docId),)));
                      },
                      child: Text(
                        'Check Status',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  if (isHosteller)
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Opacity(
                        opacity: 0.2, // Adjust opacity for the watermark
                        child: Text(
                          'H',
                          style: TextStyle(
                            fontSize: 100, // Large size for the watermark
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
                        opacity: 0.2, // Adjust opacity for the watermark
                        child: Text(
                          'D',
                          style: TextStyle(
                            fontSize: 100, // Large size for the watermark
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
      ),
    );
  }
}
