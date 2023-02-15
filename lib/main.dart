import 'package:attendence_tracker/Database/database.dart';
import 'package:attendence_tracker/Screens/signup_screen.dart';
import 'package:flutter/material.dart';
//sdgfnsfjbngfng
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyDatabase.initDb();
  runApp(const MaterialApp(
    home: SignUpScreen(),
  ));
}
