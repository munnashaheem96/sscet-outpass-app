import 'package:first_app/screens/Outpass/Student/archived_op.dart';
import 'package:first_app/screens/Outpass/Student/pending_op.dart';
import 'package:first_app/screens/Outpass/Student/request_op.dart';
import 'package:flutter/material.dart';

class OutpassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Outpass',
          style: TextStyle(
            fontWeight: FontWeight.w900
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestOpScreen()));
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 101, 141),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Request Outpass',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PendingOutpassScreen()));
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFFF69B4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Pending Request',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ArchivedOutPasses()));
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 197, 64, 250),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Archived Outpasses',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
