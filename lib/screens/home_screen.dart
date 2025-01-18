import 'dart:convert';
import 'package:first_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'Courses/course_screen.dart';
import '../../data/course_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;
  User? user;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ClipRRect(
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
                  _buildCourseSection(),
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
                "Hi, ${user!.lastName}",
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

  Widget _buildCourseSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Courses",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: _buildCourseCards(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCourseCards() {
    List<Widget> rows = [];
    for (int i = 0; i < courses.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCourseCard(courses[i]),
            if (i + 1 < courses.length) const SizedBox(width: 10),
            if (i + 1 < courses.length) _buildCourseCard(courses[i + 1]),
          ],
        ),
      );
      rows.add(const SizedBox(height: 10));
    }
    return rows;
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseScreen(
              courseName: course['name'],
              videoPath: course['videoPath'],
              description: course['description'],
            ),
          ),
        );
      },
      child: Container(
        height: 250,
        width: 180,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          color: const Color.fromARGB(255, 245, 243, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(course['imagePath'], height: 100),
            const SizedBox(height: 20),
            Text(
              course['name'],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 54, 54, 54),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${course['videoCount']} Videos",
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 110, 110, 110),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      user = User.fromJson(jsonDecode(pref.getString("userData")!));
    });
  }

  void logout() async {
    pref.setBool("isLogin", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Wrapper()),
    );
  }
}
