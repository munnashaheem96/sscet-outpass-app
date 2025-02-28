import 'package:first_app/screens/admin/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sinController = TextEditingController(); // SIN controller
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'Student'; // Default role
  String? _selectedYear;
  String? _selectedDepartment;
  User? adminUser; // Store the Admin user before signing up a new user

  List<String> roles = ['Student', 'Class Advisor', 'HOD', 'Principal', 'Security'];
  List<String> years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  List<String> departments = [
    'Mechanical Engineering',
    'Computer Science & Engineering',
    'Electronics & Communication',
    'Agriculture Engineering',
    'Biomedical Engineering',
    'Artificial Intelligence & Data Science',
    'Information Technology',
    'Computer Science Engineering - Cyber Security',
    'Science & Humanities',
  ];

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
    _storeAdminUser();
  }

  void _storeAdminUser() {
    setState(() {
      adminUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _signupUser() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create new user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstnameController.text.trim(),
        'lastName': lastnameController.text.trim(),
        'email': emailController.text.trim(),
        'sin': _selectedRole == 'Student' ? sinController.text.trim() : null, // Store SIN for students only
        'role': _selectedRole,
        'year': _selectedYear,
        'department': departmentShortForms[_selectedDepartment], // Store short form
      });

      // Re-authenticate the Admin to keep them logged in
      if (adminUser != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminUser!.email!,
          password: "Admin@123", // Replace with stored admin password (secure method recommended)
        );
      }

      // Navigate back to AdminPanel
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/signup.png', height: 200, width: 200),
                    SizedBox(height: 20),
                    Text('Please Fill Your Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    _buildTextField(firstnameController, 'First Name'),
                    SizedBox(height: 10),
                    _buildTextField(lastnameController, 'Last Name'),
                    SizedBox(height: 10),
                    _buildTextField(emailController, 'Email'),
                    SizedBox(height: 10),
                    if (_selectedRole == 'Student') _buildTextField(sinController, 'SIN Number'),
                    SizedBox(height: 10),
                    _buildPasswordField(passwordController, 'Password'),
                    SizedBox(height: 10),
                    _buildPasswordField(confirmpasswordController, 'Confirm Password'),
                    SizedBox(height: 10),
                    _buildDropdown(roles, _selectedRole, 'Role', (value) {
                      setState(() {
                        _selectedRole = value!;
                        _selectedYear = null;
                        _selectedDepartment = null;
                      });
                    }),
                    SizedBox(height: 10),
                    if (_selectedRole == 'Student' || _selectedRole == 'Class Advisor')
                      _buildDropdown(years, _selectedYear, 'Year', (value) => setState(() => _selectedYear = value)),
                    SizedBox(height: 10),
                    if (_selectedRole == 'Student' || _selectedRole == 'Class Advisor' || _selectedRole == 'HOD')
                      _buildDropdown(departments, _selectedDepartment, 'Department',
                          (value) => setState(() => _selectedDepartment = value)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signupUser,
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 115, 92), minimumSize: Size(300, 50)),
                      child: Text('SignUp', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (value) => value == null || value.isEmpty ? '$label required' : null,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (value) => value == null || value.isEmpty ? 'Enter $label' : (value.length < 6 ? 'Minimum 6 characters' : null),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedValue, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
