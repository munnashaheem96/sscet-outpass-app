import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/color/Colors.dart'; // Import AppColors
import 'package:first_app/screens/Login/signup_screen.dart'; // Import SignupScreen
import 'package:first_app/screens/Admin/user_profile.dart'; // Import UserProfileScreen

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String _searchQuery = "";
  String _selectedRole = "All";
  List<String> roles = ["All", "Student", "Class Advisor", "HOD", "Admin"];

  void _navigateToAddUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
  }

  void _navigateToUserProfile(DocumentSnapshot user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Users List", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // "Add User" Button at the Top
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: _navigateToAddUser,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add User", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Search Bar
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Role Filter Dropdown
            DropdownButton<String>(
              dropdownColor: AppColors.backgroundColor,
              iconEnabledColor: AppColors.primaryColor,
              value: _selectedRole,
              items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role, style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),),)).toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  List<DocumentSnapshot> users = snapshot.data!.docs;

                  // Filtering logic
                  users = users.where((user) {
                    String fullName = "${user['firstName']} ${user['lastName']}".toLowerCase();
                    String role = user['role'] ?? '';

                    bool matchesSearch = _searchQuery.isEmpty || fullName.contains(_searchQuery.toLowerCase());
                    bool matchesRole = _selectedRole == "All" || role == _selectedRole;

                    return matchesSearch && matchesRole;
                  }).toList();

                  if (users.isEmpty) {
                    return Center(child: Text("No users found"));
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        color: AppColors.primaryColor,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text("${user['firstName']} ${user['lastName']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text("${user['role']} | ${user['department']} | Year: ${user['year']}", style: TextStyle(color: Colors.white70)),
                          leading: Icon(Icons.person, color: Colors.white),
                          onTap: () => _navigateToUserProfile(user), // Opens User Profile
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
