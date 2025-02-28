import 'package:first_app/screens/Outpass/Security/security_verification.dart';
import 'package:flutter/material.dart'; 
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityScanPage extends StatefulWidget {
  @override
  _SecurityScanPageState createState() => _SecurityScanPageState();
}

class _SecurityScanPageState extends State<SecurityScanPage> {
  Future<void> _scanQRCode() async {
    try {
      // Use barcode_scan2 to scan QR code
      var scanResult = await BarcodeScanner.scan();
      String? scanData = scanResult.rawContent;

      if (scanData == null || scanData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No QR code detected. Please try again.')),
        );
        return;
      }

      // Fetch document from Firestore using scanned QR code
      final docRef = FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(scanData);
      final doc = await docRef.get();

      if (doc.exists) {
        // Check if the QR code is approved
        if (doc['principal_status'] == 'Approved') {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Outpass Verified')),
          );

          // Navigate to the verification page with the requestId (QR code)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecurityVerificationPage(requestId: scanData),
            ),
          );
        } else {
          // Show message if outpass is not approved
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid or Unapproved Outpass')),
          );
        }
      } else {
        // Show message if no document exists for the QR code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Outpass not found in the database')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning QR code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Security Verification',
          style: TextStyle(
            fontWeight: FontWeight.w900
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/qr-code.gif',
              width: 300,
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _scanQRCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w900
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}