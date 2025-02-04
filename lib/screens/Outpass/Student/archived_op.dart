import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ArchivedOutPasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Archived Outpasses'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Please log in to view your archived outpasses.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Outpasses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('archived_outpass')
            .where('user_id', isEqualTo: currentUser.uid) // Filter by user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No archived outpasses at the moment.'));
          }

          final outpasses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: outpasses.length,
            itemBuilder: (context, index) {
              final outpass = outpasses[index].data() as Map<String, dynamic>;
              final docId = outpasses[index].id; // Retrieve the document ID
              final isHosteller = outpass['day_scholar_or_hosteller'] == 'Hosteller';

              // Get the security status, or display 'Declined' if it's missing
              String securityStatus = outpass['security_status'] ?? 'Declined';

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
                          'Reason: ${outpass['reason']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${outpass['date']}',
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
                    bottom: 20,
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(102, 73, 239, 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        securityStatus,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
      ),
    );
  }
}
