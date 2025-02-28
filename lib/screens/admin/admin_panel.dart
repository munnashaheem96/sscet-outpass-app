import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:first_app/screens/Login/login_screen.dart';
import 'package:first_app/screens/Admin/users_list.dart';
import 'package:first_app/screens/Admin/class_wise_users.dart';
import 'package:first_app/color/Colors.dart'; // Import AppColors

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0; // Track selected tab
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    UsersListScreen(),
    ClassWiseUsersScreen(),
    Center(child: Text("Logging Out...")) // Placeholder for logout action
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _logout(); // Call logout function when Logout tab is clicked
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _logout() async {
    bool confirmLogout = await _showLogoutConfirmationDialog();
    if (confirmLogout) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())); // Redirect to login screen
    }
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Logout"),
            content: Text("Are you sure you want to log out?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Logout", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.transparent, // Light version of primary color
        color: AppColors.primaryColor, // Primary color for navbar
        buttonBackgroundColor: AppColors.primaryColor, // Active tab color
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        items: [
          Icon(Iconsax.user, size: 30, color: Colors.white), // Users List
          Icon(Iconsax.building, size: 30, color: Colors.white), // Class-Wise Users
          Icon(Iconsax.logout, size: 30, color: Colors.redAccent), // Logout
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
