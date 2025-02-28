import 'package:first_app/color/Colors.dart';
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
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        title: Text(
          'Outpass',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white
          ),
        ),
        backgroundColor: AppColors.primaryColor,
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
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                ),
                child: Center(
                  child: Text(
                    'Request Outpass',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
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
                child: Center(
                  child: Text(
                    'Pending Request',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
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
                  color: AppColors.color5,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                ),
                child: Center(
                  child: Text(
                    'Archived Outpasses',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
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