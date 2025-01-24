import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Login/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/Login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that binding is initialized before async operations.
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirstApp());
}

class FirstApp extends StatelessWidget {
  const FirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First App',
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late SharedPreferences pref;
  bool? isLoggedIn = false;
  bool? isFirstTime;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime == null) {
      return const Center(child: CircularProgressIndicator()); 
    } else if (isFirstTime == true) {
      return const OnboardingScreen();
    } else {
      return isLoggedIn == true ? HomeScreen() : LoginScreen();
    }
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = pref.getBool("isFirstTime") ?? true;
      if (isFirstTime == true) {
        pref.setBool("isFirstTime", false);
      }
      isLoggedIn = pref.getBool("isLogin");
    });
  }
}
