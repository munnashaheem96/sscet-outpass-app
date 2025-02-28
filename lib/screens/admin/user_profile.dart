import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/color/Colors.dart'; // Import AppColors

class UserProfileScreen extends StatefulWidget {
  final DocumentSnapshot user;

  UserProfileScreen({required this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _editUser() {
    TextEditingController firstNameController = TextEditingController(text: widget.user['firstName']);
    TextEditingController lastNameController = TextEditingController(text: widget.user['lastName']);
    TextEditingController roleController = TextEditingController(text: widget.user['role']);
    TextEditingController yearController = TextEditingController(text: widget.user['year'] ?? '');
    TextEditingController departmentController = TextEditingController(text: widget.user['department'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryColor,
        title: Text("Edit User", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(firstNameController, "First Name"),
            _buildTextField(lastNameController, "Last Name"),
            _buildTextField(roleController, "Role"),
            _buildTextField(yearController, "Year"),
            _buildTextField(departmentController, "Department"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                "role": roleController.text,
                "year": yearController.text,
                "department": departmentController.text,
              });
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Updated Successfully")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteUser() async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(widget.user.id).delete();
        Navigator.pop(context); // Close profile screen after deletion
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.primaryColor,
            title: Text("Confirm Delete", style: TextStyle(color: Colors.white)),
            content: Text("Are you sure you want to delete this user?", style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                _buildInfoRow("Full Name:", "${widget.user['firstName']} ${widget.user['lastName']}"),
                _buildInfoRow("Email:", widget.user['email']),
                _buildInfoRow("Role:", widget.user['role']),
                _buildInfoRow("Year:", widget.user['year'] ?? "N/A"),
                _buildInfoRow("Department:", widget.user['department'] ?? "N/A"),
                _buildInfoRow("SIN:", widget.user['sin'] ?? "N/A"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text("Edit", style: TextStyle(color: Colors.white)),
                      onPressed: _editUser,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text("Delete", style: TextStyle(color: Colors.white)),
                      onPressed: _deleteUser,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    label: Text("Back", style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(width: 10),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(), labelStyle: TextStyle(color: Colors.white)),
      style: TextStyle(color: Colors.white),
    );
  }
}
