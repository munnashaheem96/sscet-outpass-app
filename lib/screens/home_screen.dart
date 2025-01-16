import 'dart:convert';

import 'package:first_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

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
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title:
            user != null ? Text("Welcome, ${user!.firstName}") : Text("Welcome"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: user != null
          ? Center(
              child: Column(
              children: [
                Text("Username : ${user!.firstName}"),
                SizedBox(
                  height: 16,
                ),
                Text("Last Name : ${user!.lastName}"),
                SizedBox(
                  height: 16,
                ),
                Text("Email : ${user!.email}"),
                SizedBox(
                  height: 16,
                ),
                Text("Phone no : ${user!.phone}"),
                SizedBox(
                  height: 16,
                ),
              ],
            ))
          : SizedBox(),
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

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Wrapper()));
  }
}