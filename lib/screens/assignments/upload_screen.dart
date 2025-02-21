import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadAssignmentScreen extends StatefulWidget {
  @override
  _UploadAssignmentScreenState createState() => _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  String _fileUrl = "";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  final String githubRepo = "munnashaheem96/storage_sscet-app"; // Replace with your repo
  final String githubToken = "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"; // Store securely
  final String githubBranch = "main"; // Change if needed
  final String githubPath = "uploads/"; // Folder in the repo

  String? _selectedYear;
  String? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final userData = doc.data();
        setState(() {
          _selectedYear = userData?['year'];
          _selectedDepartment = userData?['department'];
        });
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _pickFile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedFile = File(pickedFile.path));
    }
  }

  Future<void> _uploadFileToGitHub() async {
    if (_selectedFile == null || 
        _titleController.text.isEmpty || 
        _descriptionController.text.isEmpty || 
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields and select a file.")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      String fileName = _selectedFile!.path.split('/').last;
      String githubFilePath = "$githubPath$fileName";

      // Convert file to Base64
      List<int> fileBytes = await _selectedFile!.readAsBytes();
      String base64File = base64Encode(fileBytes);

      // Commit message with assignment details
      String commitMessage = "Upload: ${_titleController.text}, Year: $_selectedYear, Dept: $_selectedDepartment";

      // GitHub API request
      final url = Uri.parse("https://api.github.com/repos/$githubRepo/contents/$githubFilePath");
      final response = await http.put(
        url,
        headers: {
          "Authorization": "token $githubToken",
          "Accept": "application/vnd.github.v3+json",
        },
        body: jsonEncode({
          "message": commitMessage,
          "content": base64File,
          "branch": githubBranch,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String uploadedFileUrl = jsonResponse["content"]["html_url"];
        
        setState(() => _fileUrl = uploadedFileUrl);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File uploaded successfully!")));

        // Now store data to Firestore
        await _storeDataToFirestore(uploadedFileUrl);
      } else {
        print(response.body);
        throw Exception("GitHub upload failed: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _storeDataToFirestore(String fileUrl) async {
    try {
      await FirebaseFirestore.instance.collection('assignments').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'last_date': _selectedDate?.toIso8601String(),
        'file_url': fileUrl,
        'year': _selectedYear,
        'department': _selectedDepartment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Assignment data saved successfully!")));
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Firestore Error: $e")));
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedFile = null;
      _selectedDate = null;
      _fileUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        title: Text(
          "Upload Assignments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/assignment.png',
                width: 150,
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                  labelText: "Assignment Title",
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none
                  ),
                ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black),
                  ),
                  maxLines: 5,
                ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: TextEditingController(
                  text: _selectedDate == null ? "" : _selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Select Last Date",
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                  ),
                ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Selected File",
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _pickFile,
                  ),
                  ),
                  controller: TextEditingController(
                  text: _selectedFile == null ? "No file selected" : _selectedFile!.path.split('/').last,
                  ),
                ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black
                ),
                onPressed: _isUploading ? null : _uploadFileToGitHub,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: _isUploading ? CircularProgressIndicator(color: Colors.black,) : Text("Upload Assignment Topics"),
                ),
              ),
              if (_fileUrl.isNotEmpty) Text("File uploaded: $_fileUrl"),
            ],
          ),
        ),
      ),
    );
  }
}