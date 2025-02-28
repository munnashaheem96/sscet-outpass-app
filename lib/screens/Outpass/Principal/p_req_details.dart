import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrincipalRequestDetailsScreen extends StatelessWidget {
  final String requestId;
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

  PrincipalRequestDetailsScreen({required this.requestId});

  Future<DocumentSnapshot> _fetchRequestDetails() async {
    return await FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(requestId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Request Details',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchRequestDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available'));
          } else {
            var data = snapshot.data!;
            String name = data['name'] ?? 'N/A';
            String sin = data['sin'] ?? 'N/A';
            String year = data['year'] ?? 'N/A';
            String reason = data['reason'] ?? 'N/A';
            DateTime? date = (data['date'] != null) ? DateTime.parse(data['date']) : null;
            String? time = data['time'];
            String? type = data['day_scholar_or_hosteller'];
            final departmentShortForm = departmentShortForms[data['department']] ?? data['department'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildDetailContainer('Name of The Student', name),
                  _buildDetailContainer('SIN Number', sin),
                  _buildDetailContainer('Year & Department', '$year & $departmentShortForm'),
                  _buildDetailContainer('Reason for Leaving', reason),
                  _buildDetailContainer('Date of Leaving', date != null ? DateFormat('yyyy-MM-dd').format(date) : 'N/A'),
                  _buildDetailContainer('Time of Leaving', time ?? 'N/A'),
                  _buildDetailContainer('Day Scholar or Hosteller', type ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildStatusContainer('Request Submitted', 'Approved'),
                  _buildStatusContainer('Waiting for Class Advisor Approval', data['class_advisor_status']),
                  _buildStatusContainer('Waiting for HOD Approval', data['hod_status']),
                  _buildStatusContainer('Waiting for Principal Approval', data['principal_status']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _updateRequestStatus(context, 'Approved');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updateRequestStatus(context, 'Declined');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Decline', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _updateRequestStatus(BuildContext context, String status) async {
    FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(requestId)
        .update({
      'principal_status': status,
      if (status == 'Declined') 'principal_status': 'Declined',
    }).then((_) async {
      if (status == 'Declined') {
        await _moveToArchived(requestId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Declined and Archived')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request $status')));
      }

      Navigator.pop(context);
    });
  }

  Future<void> _moveToArchived(String requestId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(requestId)
        .get();

    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection('archived_requests')
          .doc(requestId)
          .set(doc.data() as Map<String, dynamic>);

      await FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(requestId)
          .delete();
    }
  }

  Widget _buildStatusContainer(String status, String statusValue) {
    IconData iconData;
    Color iconColor;

    if (statusValue == 'Pending') {
      iconData = Icons.remove_circle;
      iconColor = Colors.grey;
    } else if (statusValue == 'Approved') {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else if (statusValue == 'Declined') {
      iconData = Icons.cancel_outlined;
      iconColor = Colors.red;
    } else {
      iconData = Icons.remove;
      iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 73, 239, 0.1),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(status, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Icon(iconData, color: iconColor),
        ],
      ),
    );
  }

  Widget _buildDetailContainer(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 73, 239, 0.1),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}