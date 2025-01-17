import 'dart:convert';
import 'package:first_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'Courses/flutter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;
  User? user = null;

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
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Color(0xFF6649EF),
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'School',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.logout_rounded),
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
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      height: screenHeight * 0.3,
                      color:Color(0xFF6649EF) ,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18,70,18,0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.menu, color: const Color.fromARGB(255, 255, 255, 255)),
                                Icon(Icons.notifications, color: const Color.fromARGB(255, 255, 255, 255)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Hi, ${user!.lastName}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(255, 255, 255, 255),
                                hintText: "Search here...",
                                hintStyle: TextStyle(
                                  color: const Color.fromARGB(181, 0, 0, 0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD700),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.category,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Category",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF32CD32),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.play_lesson_outlined,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Classes",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF87CEEB),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.book,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Free Course",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF69B4),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.store,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Book Store",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 197, 64, 250),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.play_circle_fill,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Live Course",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 101, 141),
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                color: Colors.white,
                                Icons.leaderboard,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Leaderboard",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,0,16,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,0,16,0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                            onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FlutterScreen()),
                              );
                            },
                            child: Container(
                              height: 250,
                              width: 180,
                              decoration: BoxDecoration(
                              boxShadow: List.filled(20, BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 4),
                              )),
                              color: const Color.fromARGB(255, 245, 243, 255),
                              borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Image(
                                  image: AssetImage("assets/images/flutter.webp"),
                                  height: 100,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Flutter",
                                  style: TextStyle(
                                  color: const Color.fromARGB(255, 54, 54, 54),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "55 Videos",
                                  style: TextStyle(
                                  color: const Color.fromARGB(255, 110, 110, 110),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ],
                              ),
                              ),
                            ),
                            ),
                          SizedBox(width: 10,),
                          Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                              boxShadow: List.filled(20, BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 4),
                              )),
                              color: Color.fromARGB(255, 245, 243, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage("assets/images/python.png"),
                                    height: 100,),
                                    SizedBox(height: 20,),
                                    Text(
                                      "Python",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 54, 54, 54),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      "25 Videos",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 110, 110, 110),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                              boxShadow: List.filled(20, BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 4),
                              )),
                              color: Color.fromARGB(255, 245, 243, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage("assets/images/react.webp"),
                                    height: 100,),
                                    SizedBox(height: 20,),
                                    Text(
                                      "React Native",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 54, 54, 54),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      "30 Videos",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 110, 110, 110),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                              boxShadow: List.filled(20, BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 4),
                              )),
                              color: Color.fromARGB(255, 245, 243, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage("assets/images/cpp.png"),
                                    height: 100,),
                                    SizedBox(height: 20,),
                                    Text(
                                      "C++",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 54, 54, 54),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      "23 Videos",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 110, 110, 110),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
          )
          : Container(),
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
      MaterialPageRoute(builder: (BuildContext context) => Wrapper()),
    );
  }
}
