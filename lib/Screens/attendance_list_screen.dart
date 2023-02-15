import 'package:attendence_tracker/Screens/login_screen.dart';
import 'package:attendence_tracker/Widgets/custom_attendance_tile.dart';
import 'package:flutter/material.dart';

import '../Utils/attendance.dart';
import '../Widgets/custom_appbar.dart';

List<Attendance> attendanceList = [];

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  @override
  void initState() {
    super.initState();
    _addLastMonthAttendance();
  }

  final TextEditingController _searchController = TextEditingController();
  final List<Attendance> _filteredAttendanceList = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(
            showImg: true,
            icons: "",
            lable: 'Attendance List',
            fun: () {},
            sizechange: size.width * 0.04,
            size: size,
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            height: size.height * 0.065,
            width: size.width * 80,
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .05, vertical: size.height * 0.02),
            decoration: BoxDecoration(
                // color: Colors.black,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(size.height * 5)),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.035, vertical: size.height * .0065),
            child: TextField(
              onTap: () {
                _selectDate(context);
              },
              controller: _searchController,
              readOnly: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.grey[700],
                    size: size.height * 0.03,
                  ),
                  hintText: "Search by date",
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTitle(size, "Name"),
              _buildTitle(size, "Duration"),
              _buildTitle(size, "Date"),
              _buildTitle(size, "CheckIn"),
              _buildTitle(size, "CheckOut")
            ],
          ),
          const Divider(),
          Expanded(
            child: _filteredAttendanceList.isEmpty
                ? const Center(
                    child: Text("No Data Available !"),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                        left: size.width * .025,
                        top: size.height * .023,
                        right: size.width * .025),
                    itemCount: _filteredAttendanceList.length,
                    itemBuilder: (context, index) => AttendanceTile(
                      size: size,
                      attendance: _filteredAttendanceList[index],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(Size size, String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black,
          fontSize: size.height * 0.02,
          fontWeight: FontWeight.bold),
    );
  }

  _selectDate(BuildContext context) async {
    _filteredAttendanceList.clear();
    Duration oneDay = const Duration(days: 1);
    final pickedDate = await showDateRangePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2019),
    );
    if (pickedDate != null) {
      _searchController.text =
          "${pickedDate.start.toString().split(" ")[0]} - ${pickedDate.end.toString().split(" ")[0]}";
      for (var attendance in attendanceList) {
        DateTime attendanceDate = DateTime.parse(attendance.date);
        bool isValid =
            attendanceDate.isAfter(pickedDate.start.subtract(oneDay)) &&
                attendanceDate.isBefore(pickedDate.end.add(oneDay));
        if (isValid && attendance.name == currentUserInfo.name) {
          _filteredAttendanceList.add(attendance);
        }
      }
      setState(() {});
    } else {
      _addLastMonthAttendance();
    }
    return;
  }

  _addLastMonthAttendance() {
    for (var attendance in attendanceList) {
      // DateTime attendanceDate = DateTime.parse(attendance.date);
      // bool isValid = attendanceDate
      //     .isAfter(DateTime.now().subtract(const Duration(days: 31)));
      // if (isValid && attendance.name == currentUserInfo.name) {
      _filteredAttendanceList.add(attendance);
      // }
    }
    setState(() {});
  }
}
