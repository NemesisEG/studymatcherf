import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studymatcherf/home_page.dart';
import 'package:studymatcherf/login_page.dart';
import 'package:studymatcherf/register_page.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Add your Firebase options here
    options: const FirebaseOptions(
        apiKey: "AIzaSyBRIUSFtmqyD4xLG-yInVFKraYFiCIVXgQ",
        authDomain: "groupstudyplanner-96c44.firebaseapp.com",
        databaseURL:
            "https://groupstudyplanner-96c44-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "groupstudyplanner-96c44",
        storageBucket: "groupstudyplanner-96c44.appspot.com",
        messagingSenderId: "140410400136",
        appId: "1:140410400136:web:c113da348491650dbd5e3d",
        measurementId: "G-EJ23GH0CDK"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMatcher',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Set SplashScreen as initial route
      initialRoute: '/splash',
      routes: {
        // Define routes
        '/splash': (context) => SplashScreen(), // SplashScreen route
        '/': (context) => LoginPage(),    // Login page route
        '/home': (context) => HomePage(),       // Home page route
        '/register': (context) => RegisterPage(), // Registration page route
      },
    );
  }
}
