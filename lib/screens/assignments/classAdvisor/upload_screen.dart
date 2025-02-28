import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/color/Colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _maxMarksController = TextEditingController(); // New controller for maximum marks
  DateTime? _selectedDate;

  String? _selectedYear;
  String? _selectedDepartment;

  final String cloudinaryApiKey = "iU1ErJBaUZ8beEHXsW9ptu4Y2qM";
  final String cloudinaryCloudName = "dvigcd89z";
  final String cloudinaryUploadPreset = "assignmentdata";

  final ImagePicker _picker = ImagePicker();

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
        setState(() {
          _selectedYear = doc.data()?['year'];
          _selectedDepartment = doc.data()?['department'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      PermissionStatus status = await Permission.photos.request();
      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          setState(() {
            _selectedFile = File(image.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No image selected.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission denied to access images.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _uploadFileToCloudinary() async {
    if (_selectedFile == null ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null ||
        _maxMarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields and select an image.")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      String cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload";

      var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUploadUrl));
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.files.add(await http.MultipartFile.fromPath("file", _selectedFile!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        String uploadedFileUrl = jsonResponse["secure_url"];
        setState(() => _fileUrl = uploadedFileUrl);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image uploaded successfully!")));
        await _storeDataToFirestore(uploadedFileUrl);
      } else {
        throw Exception("Image upload failed: ${jsonResponse['error']['message']}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _storeDataToFirestore(String fileUrl) async {
    try {
      final maxMarks = int.tryParse(_maxMarksController.text) ?? 100; // Default to 100 if invalid

      await FirebaseFirestore.instance.collection('assignments').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'last_date': _selectedDate?.toIso8601String(),
        'file_url': fileUrl,
        'year': _selectedYear,
        'department': _selectedDepartment,
        'timestamp': FieldValue.serverTimestamp(),
        'max_marks': maxMarks, // Add maximum marks to Firestore
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Assignment data saved successfully!")));
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Firestore Error: $e")));
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _maxMarksController.clear(); // Clear maximum marks
    setState(() {
      _selectedFile = null;
      _selectedDate = null;
      _fileUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        backgroundColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon (using the assignment icon as an example)
              Image.asset(
                'assets/images/assignment.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              // Headline
              Text(
                'Upload Assignment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              // Subtitle
              Text(
                'Post your assignment today and engage your students.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              // Input Fields
              _buildInputField(_titleController, "Assignment Title"),
              SizedBox(height: 16),
              _buildInputField(_descriptionController, "Description", isMultiline: true),
              SizedBox(height: 16),
              _buildInputField(_maxMarksController, "Maximum Marks", keyboardType: TextInputType.number), // New field
              SizedBox(height: 16),
              _buildInputField(_dateController, "Select Last Date",
                  isReadOnly: true, icon: Icons.calendar_today, onTap: _pickDate),
              SizedBox(height: 16),
              _buildImagePicker(),
              SizedBox(height: 30),
              // Upload Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isUploading ? null : _uploadFileToCloudinary,
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text("Upload Assignment", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {bool isMultiline = false, bool isReadOnly = false, IconData? icon, VoidCallback? onTap, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      keyboardType: keyboardType ?? TextInputType.text, // Default to text, use number for max marks
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: icon != null
            ? IconButton(
                icon: Icon(icon, color: Colors.grey[600]),
                onPressed: onTap,
              )
            : null,
      ),
      maxLines: isMultiline ? 5 : 1,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildImagePicker() {
    return _buildInputField(
      TextEditingController(text: _selectedFile?.path.split('/').last ?? "No image selected"),
      "Select Image",
      isReadOnly: true,
      icon: Icons.image,
      onTap: _pickImage,
    );
  }
}