import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestOpScreen extends StatefulWidget {
  @override
  _RequestOpScreenState createState() => _RequestOpScreenState();
}

class _RequestOpScreenState extends State<RequestOpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _returnTimeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? _selectedCategory;
  String? _name;
  String? _sin;
  String? _year;
  String? _department;

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
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _name = "${userDoc['firstName']} ${userDoc['lastName']}";
          _sin = userDoc['sin'];
          _year = userDoc['year'];
          _department = userDoc['department'];
        });
      }
    }
  }

  void _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        controller.text = selectedTime.format(context);
      });
    }
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('outpass_requests').add({
          'name': _name,
          'sin': _sin,
          'year': _year,
          'department' : _department,
          'reason': _reasonController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'day_scholar_or_hosteller': _selectedCategory,
          'user_id': user.uid,
          'class_advisor_status': 'Pending',
          'hod_status': 'Pending',
          'principal_status': 'Pending',
          'qr_code': null,
          'created_at': FieldValue.serverTimestamp(),
          if (_selectedCategory == 'Hosteller') ...{
            'return_date': _returnDateController.text,
            'return_time': _returnTimeController.text,
          },
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Outpass request submitted successfully!')),

        );

        _formKey.currentState!.reset();
        _dateController.clear();
        _timeController.clear();
        _returnDateController.clear();
        _returnTimeController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/sscet1.jpg'), // Your image here
                    fit: BoxFit.cover,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent, // Make it transparent at the top
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromRGBO(102, 73, 239, 1),
                          ),
                        ]
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Request Outpass',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromRGBO(102, 73, 239, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    _buildDetailContainer('Name', '$_name'),
                    _buildDetailContainer('SIN Number', '$_sin'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailContainerDoubleSmall('Year', '$_year'),
                        _buildDetailContainerDoubleBig('Department', departmentShortForms[_department ?? ''] ?? '$_department')
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: 'Reason for Outpass',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Please enter a reason' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date of Leaving',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, _dateController),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Time of Leaving',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context, _timeController),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Day Scholar or Hosteller',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'Day Scholar', child: Text('Day Scholar')),
                        DropdownMenuItem(value: 'Hosteller', child: Text('Hosteller')),
                      ],
                      onChanged: (value) => setState(() => _selectedCategory = value),
                    ),
                    if (_selectedCategory == 'Hosteller') ...[
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _returnDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Return Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context, _returnDateController),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _returnTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Return Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        onTap: () => _selectTime(context, _returnTimeController),
                      ),
                    ],
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(102, 73, 239, 1),
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        ),
                        child: Text(
                          'Submit Request',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildDetailContainerDoubleSmall(String label, String value) {
    return Container(
      width: 182,
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
          SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContainerDoubleBig(String label, String value) {
    return Container(
      width: 182,
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
          SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
