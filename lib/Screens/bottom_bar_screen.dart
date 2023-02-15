import 'package:attendence_tracker/Screens/attendance_list_screen.dart';
import 'package:attendence_tracker/Screens/dashboard_screen.dart';
import 'package:attendence_tracker/Screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;
  List tabs = const [HomeScreen(), AttendanceListScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 100;

    return Scaffold(
      bottomNavigationBar: Container(
        height: size.height * 11,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black38))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomBarItem(size, Icons.home, "Home", 0),
            _buildBottomBarItem(
                size, Icons.list_alt_sharp, "Attendance List", 1),
            _buildBottomBarItem(size, Icons.person, "Profile", 2),
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  _buildBottomBarItem(Size size, IconData iconData, String label, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: size.height * 3,
            color: selectedIndex == index ? Colors.blue : Colors.grey,
          ),
          SizedBox(height: size.height),
          Text(
            label,
            style: TextStyle(
                color: selectedIndex == index ? Colors.blue : Colors.grey,
                fontSize: size.height * 1.5),
          )
        ],
      ),
    );
  }
}
