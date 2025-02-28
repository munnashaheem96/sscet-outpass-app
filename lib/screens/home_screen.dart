import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:first_app/bottom%20navigation/bottom_nav_bar.dart';
import 'package:first_app/data/models/user_model.dart';
import 'package:first_app/screens/Outpass/ClassAdvisor/ca_approvel_page.dart';
import 'package:first_app/screens/Outpass/HOD/hod_approvel_page.dart';
import 'package:first_app/screens/Outpass/Principal/p_approvel_page.dart';
import 'package:first_app/screens/Outpass/Security/security_scan_page.dart';
import 'package:first_app/screens/Login/login_screen.dart';
import 'package:first_app/screens/assignments/classAdvisor/class_advisor_assignment.dart';
import 'package:first_app/screens/assignments/classAdvisor/upload_screen.dart';
import 'package:first_app/screens/assignments/student/student_assignment.dart';
import 'package:first_app/screens/assignments/student/view_assignments.dart';
import 'package:flutter/material.dart';
import 'Outpass/outpass_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:first_app/color/Colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: user != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(screenHeight),
                      const SizedBox(height: 20),
                      _buildCategories(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Services',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Check user role and display appropriate container
                            user?.role == 'Student'
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OutpassScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: AppColors.color1,
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/exit.png'),
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Out Pass',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StudentAssignment(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: AppColors.color2,
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/assignment.png'),
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Assignments',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: AppColors.color3,
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/announcement.png'),
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Announcements',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: AppColors.color4,
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/attendance.png'),
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Attendance',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 80),
                                    ],
                                  )
                                : user?.role == 'Class Advisor'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ClassAdvisorApprovalScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: AppColors.color5,
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/exit.png'),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Center(
                                                        child: Text(
                                                          'Review Outpasses',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppColors.primaryColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: AppColors.color6,
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/exit.png'),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Student Contact',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ClassAdvisorAssignment(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: AppColors.color1,
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/assignment.png'),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Assignments',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: AppColors.color2,
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/attendance.png'),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Mark Attendance',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 80),
                                        ],
                                      )
                                    : user?.role == 'HOD'
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HODApprovalScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: AppColors.color3,
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/exit.png'),
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Review Outpasses',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.primaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : user?.role == 'Principal'
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => PrincipalApprovalScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: AppColors.color4,
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/exit.png'),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Review Outpasses',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : user?.role == 'Security'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => SecurityScanPage(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: AppColors.color5,
                                                      ),
                                                      width: 190,
                                                      height: 250,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Image(
                                                            image: AssetImage('assets/images/exit.png'),
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            'Review Outpasses',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: BottomNavBar(_selectedIndex = 1))
      ],
    );
  }

  Widget _buildHeader(double screenHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        height: screenHeight * 0.3,
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 70, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, color: Colors.white),
                  Icon(Icons.notifications, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hi, ${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search here...",
                  hintStyle: TextStyle(color: AppColors.primaryColor.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildCategoryItems([
            {'color': AppColors.color1, 'icon': Iconsax.category_2, 'text': 'Category'},
            {'color': AppColors.color2, 'icon': Iconsax.video_play4, 'text': 'Classes'},
            {'color': AppColors.color3, 'icon': Iconsax.book, 'text': 'Free Course'},
          ]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildCategoryItems([
            {'color': AppColors.color4, 'icon': Iconsax.building, 'text': 'Book Store'},
            {'color': AppColors.color5, 'icon': Iconsax.play, 'text': 'Live Course'},
            {'color': AppColors.color6, 'icon': Iconsax.cup, 'text': 'Leaderboard'},
          ]),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryItems(List<Map<String, dynamic>> items) {
    return items.map((item) {
      return Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: item['color'],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(item['icon'], color: AppColors.primaryColor, size: 35),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item['text'],
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }).toList();
  }

  void fetchUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            user = UserModel(
              id: userDoc.id,
              firstName: userData['firstName'] ?? '',
              lastName: userData['lastName'] ?? '',
              email: userData['email'] ?? '',
              role: userData['role'] ?? '',
              sin: userData['sin'],
              year: userData['year'],
              department: userData['department'],
            );
          });
        } else {
          print("User document does not exist.");
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}