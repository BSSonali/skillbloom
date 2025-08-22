import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillbloom/screens/dashboard_screen.dart';
import 'auth/signup_screen.dart'; // 👈 Replace with your path
import 'auth/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillBloom',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:  LoginScreen(), // 👈 This will load signup screen
    );
  }
}
