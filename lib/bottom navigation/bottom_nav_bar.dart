import 'package:first_app/color/Colors.dart';
import 'package:first_app/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class BottomNavBar extends StatefulWidget {
  const BottomNavBar(int i, {super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
    
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent, // Background behind the bar
      color: AppColors.primaryColor, // Navigation bar color
      buttonBackgroundColor: AppColors.primaryColor, // Active button color
      height: 75,
      animationDuration: Duration(milliseconds: 300),
      index: _selectedIndex, // Current selected index
      items: <Widget>[
        Icon(Iconsax.home, size: 30, color: AppColors.secondaryColor),
        Icon(Iconsax.building_3, size: 30, color: AppColors.secondaryColor),
        Icon(Iconsax.heart, size: 30, color: AppColors.secondaryColor),
        Icon(Iconsax.favorite_chart, size: 30, color: AppColors.secondaryColor),
        IconButton(onPressed: logout, icon: Icon(Iconsax.logout, color: AppColors.secondaryColor))
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
  void logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}