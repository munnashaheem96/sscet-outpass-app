import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:first_app/data/models/user_model.dart';
import 'package:first_app/screens/Outpass/ClassAdvisor/archieved_class.dart';
import 'package:first_app/screens/Outpass/ClassAdvisor/ca_approvel_page.dart';
import 'package:first_app/screens/Outpass/HOD/hod_approvel_page.dart';
import 'package:first_app/screens/Outpass/Principal/p_approvel_page.dart';
import 'package:first_app/screens/Outpass/Security/security_scan_page.dart';
import 'package:first_app/screens/Login/login_screen.dart';
import 'package:first_app/screens/Outpass/Student/archived_op.dart';
import 'package:flutter/material.dart';
import 'Outpass/outpass_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user; // Use your custom User model.
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(102, 73, 239, 1),
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: logout,
              ),
              label: 'Logout',
            ),
          ],
        ),
      ),
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
                          ),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                            color: Colors.blue,
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
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Out Pass',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
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
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Assignments',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                SizedBox(height: 16,),
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
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Announcemnets',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
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
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Time Table',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ],
                            )
                            : user?.role == 'Class Advisor'
                                ? Row(
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
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Review Outpasses',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ArchivedClass(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Color.fromRGBO(102, 73, 239, 0.1),
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Archived Outpasses',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                            color: Colors.blue[200],
                                          ),
                                          width: 190,
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/outpass.png'),
                                                height: 120,
                                                width: 120,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Review Outpasses',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
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
                                                color: Colors.blue[200],
                                              ),
                                              width: 190,
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/outpass.png'),
                                                    height: 120,
                                                    width: 120,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    'Review Outpasses',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
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
                                                    color: Colors.blue[200],
                                                  ),
                                                  width: 190,
                                                  height: 250,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/outpass.png'),
                                                        height: 120,
                                                        width: 120,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        'Review Outpasses',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(), // Default if the role is not found.
                      ],
                    ),
                  ),
                  SizedBox(height: 16)
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
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
        color: const Color(0xFF6649EF),
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
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(181, 0, 0, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
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
            {'color': Color(0xFFFFD700), 'icon': Icons.category, 'text': 'Category'},
            {'color': Color(0xFF32CD32), 'icon': Icons.play_lesson_outlined, 'text': 'Classes'},
            {'color': Color(0xFF87CEEB), 'icon': Icons.book, 'text': 'Free Course'},
          ]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildCategoryItems([
            {'color': Color(0xFFFF69B4), 'icon': Icons.store, 'text': 'Book Store'},
            {'color': Color.fromARGB(255, 197, 64, 250), 'icon': Icons.play_circle_fill, 'text': 'Live Course'},
            {'color': Color.fromARGB(255, 0, 101, 141), 'icon': Icons.leaderboard, 'text': 'Leaderboard'},
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
                child: Icon(item['icon'], color: Colors.white, size: 35),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item['text'],
              style: const TextStyle(
                color: Colors.black,
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
            id: userDoc.id, // Ensure the document ID is passed correctly
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
      MaterialPageRoute(builder: (context) => LoginScreen()), // Use appropriate screen.
    );
  }
}
