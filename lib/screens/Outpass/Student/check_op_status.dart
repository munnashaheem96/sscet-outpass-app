import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/color/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckOpStatus extends StatefulWidget {
  final String requestId;

  const CheckOpStatus({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  _CheckOpStatusState createState() => _CheckOpStatusState();
}

class _CheckOpStatusState extends State<CheckOpStatus> {
  late Future<DocumentSnapshot> _requestDetails;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _requestDetails = FirebaseFirestore.instance
          .collection('outpass_requests')
          .doc(widget.requestId)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Outpass Status',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.secondaryColor),
            onPressed: _refreshData, // Call the refresh function
          ),
        ],
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _requestDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available'));
          } else {
            var data = snapshot.data!;
            String reason = data['reason'] ?? 'N/A';
            DateTime? date =
                (data['date'] != null) ? DateTime.parse(data['date']) : null;
            String? time = data['time'];
            String? type = data['day_scholar_or_hosteller'];

            bool allStatusesApproved = data['class_advisor_status'] == 'Approved' &&
                data['hod_status'] == 'Approved' &&
                data['principal_status'] == 'Approved';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailContainer('Reason for Leaving', reason),
                  _buildDetailContainer(
                      'Date of Leaving',
                      date != null
                          ? DateFormat('yyyy-MM-dd').format(date)
                          : 'N/A'),
                  _buildDetailContainer('Time of Leaving', time ?? 'N/A'),
                  _buildDetailContainer('Day Scholar or Hosteller', type ?? 'N/A'),
                  const SizedBox(height: 8),
                  Divider(),
                  const SizedBox(height: 8),
                  _buildStatusContainer(
                      'Request Submitted', 'Approved'),
                  _buildStatusContainer('Waiting for Class Advisor Approval',
                      data['class_advisor_status']),
                  _buildStatusContainer('Waiting for HOD Approval',
                      data['hod_status']),
                  _buildStatusContainer('Waiting for Principal Approval',
                      data['principal_status']),
                  const SizedBox(height: 16),
                  if (allStatusesApproved)
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(102, 73, 239, 1)),
                        ),
                        onPressed: () {
                          _showQrCodeDialog(context, widget.requestId);
                        },
                        child: Text(
                          'Show QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('QR CODE'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: QrImageView(
              data: docId,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
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
        color: AppColors.color4,
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
            status,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Icon(
            iconData,
            color: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContainer(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.color4,
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
}