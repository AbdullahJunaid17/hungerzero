import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart ';
import 'package:flutter/material.dart';
import 'loginpage.dart'; // updated path since it's directly in lib/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(HungerZeroApp());
}

class HungerZeroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HungerZero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // no parameters needed here if it's built that way
    );
  }
}
