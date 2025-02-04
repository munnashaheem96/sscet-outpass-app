import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityVerificationPage extends StatefulWidget {
  final String requestId;

  const SecurityVerificationPage({Key? key, required this.requestId})
      : super(key: key);

  @override
  _SecurityVerificationPageState createState() =>
      _SecurityVerificationPageState();
}

class _SecurityVerificationPageState extends State<SecurityVerificationPage> {
  bool _isNameVerified = false;
  bool _isSINVerified = false;
  String? _name;
  String? _sin;

  @override
  void initState() {
    super.initState();
    _fetchRequestDetails(); // Fetch user details on page load
  }

  Future<void> _fetchRequestDetails() async {
    // Fetch outpass request data from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(widget.requestId)
        .get();

    if (doc.exists) {
      setState(() {
        // Store the user's name and SIN number
        _name = doc['name'];
        _sin = doc['sin'];
      });
    }
  }

  Future<void> _moveToArchived(String requestId) async {
    // Fetch the document from the "outpass_requests" collection
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(requestId)
        .get();

    if (doc.exists) {
      // Move the document to the "archived_outpass" collection
      await FirebaseFirestore.instance
          .collection('archived_outpass')
          .doc(requestId)
          .set(doc.data() as Map<String, dynamic>);

      // Delete the document from the "outpass_requests" collection
      await FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(requestId)
          .delete();
    }
  }

  // Show confirmation dialog for exit and mark checkboxes as checked
  void _showExitConfirmation() {
    setState(() {
      _isNameVerified = true; // Automatically check the "Name on ID Card"
      _isSINVerified = true;  // Automatically check the "SIN Number on ID Card"
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Exit Confirmation'),
          content: Text('Are you sure you want to mark this outpass as "Exited"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _markExit();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog for decline
  void _showDeclineConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Decline Confirmation'),
          content: Text('Are you sure you want to decline this outpass request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitVerification(false); // Decline action
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _submitVerification(bool isVerified) async {
    // Logic for verification
    if (isVerified) {
      // If both details are verified, approve the outpass and remove QR code
      await FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(widget.requestId)
          .update({
        'security_status': 'Verified',
        'qr_code': null, // Remove QR code after verification
      });

      // Move to archived collection
      await _moveToArchived(widget.requestId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outpass verified successfully and archived.')),
      );
    } else {
      // If declined, show a message and decline the outpass
      await FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(widget.requestId)
          .update({
        'security_status': 'Declined',
      });

      // Move to archived collection as declined
      await _moveToArchived(widget.requestId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outpass declined and archived.')),
      );
    }

    Navigator.pop(context); // Close the verification screen
  }

  void _markExit() async {
    // Mark the outpass as Exited and move it to archived collection
    await FirebaseFirestore.instance
        .collection('outpass_requests')
        .doc(widget.requestId)
        .update({
      'security_status': 'Exited', // Mark as exited
    });

    // Move to archived collection as Exited
    await _moveToArchived(widget.requestId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Outpass marked as Exited and archived.')),
    );

    Navigator.pop(context); // Close the verification screen after exit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Security Verification',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_name != null && _sin != null) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildDetailContainer('Name of The Student', _name!),
                  SizedBox(height: 8),
                  _buildDetailContainer('SIN Number', _sin!),
                ],
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              // Checkboxes for verification
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  title: Text('Name on ID Card'),
                  value: _isNameVerified,
                  onChanged: (value) {
                    setState(() {
                      _isNameVerified = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  title: Text('SIN Number on ID Card'),
                  value: _isSINVerified,
                  onChanged: (value) {
                    setState(() {
                      _isSINVerified = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              // Submit buttons
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _showExitConfirmation, // Show confirmation dialog for exit
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'EXIT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8), // Add some space between buttons
                    ElevatedButton(
                      onPressed: _showDeclineConfirmation, // Show confirmation dialog for decline
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'DECLINE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailContainer(String label, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
