// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:attendence_tracker/Screens/login_screen.dart';
import 'package:attendence_tracker/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Database/database.dart';
import '../Utils/attendance.dart';
import '../Utils/user_info.dart';
import '../Widgets/custom_appbar.dart';
import '../Widgets/custom_attendance_tile.dart';
import 'attendance_list_screen.dart';

//name, check in & out, total duration, date
Color primaryColor = const Color(0xff0166C4);
List<Attendance> _attendanceList = [];

bool isCheckedIn = false;
late Timer timer;
int attendanceId = -5;
String checkedInTime = '', checkedOutTime = '';
RxString totalDuration = ''.obs;
DateTime checkInDateTime = DateTime(2023);
bool isDone = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentDay = DateTime.now().day.toString();
  int currentMonth = DateTime.now().month;
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    fetchAllData();
    if (isCheckedIn) {
      Duration duration = DateTime.now().difference(checkInDateTime);
      totalDuration.value = "${duration.inHours}h ${duration.inMinutes}m";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              showImg: true,
              icons: "",
              lable: 'Dashboard',
              fun: () {},
              sizechange: size.width * 0.04,
              size: size,
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.05, horizontal: size.width * 0.01),
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 5),
                  ]),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.035),
                  GestureDetector(
                    onTap: () async {
                      if (isDone && !isCheckedIn) {
                        showMessage(
                            context, "You've already completed attendance");
                        return;
                      }

                      checkInCheckOut(context);

                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () {
                          setState(() {});
                        },
                      );
                    },
                    child: Container(
                      height: size.height * 0.17,
                      width: size.height * 0.17,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              blurRadius: 12)
                        ],
                        border: Border.all(
                          width: 3,
                          color: primaryColor.withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$currentDay ${months[currentMonth - 1]}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.width * 0.06),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                isCheckedIn ? "Check Out" : "Check In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.width * 0.04),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    isCheckedIn ? "Let's wrap the day!" : "Let's start the day",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.07),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            // Image.asset(AppImage.checkIn,
                            //     height: size.height * 0.03,
                            //     fit: BoxFit.contain),
                            SizedBox(height: size.height * 0.007),
                            Text(
                              checkedInTime.isEmpty ? '--' : checkedInTime,
                              style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              "Check In",
                              style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Image.asset(AppImage.checkOut,
                            //     height: size.height * 0.03,
                            //     fit: BoxFit.contain),
                            SizedBox(height: size.height * 0.007),
                            Text(
                              checkedOutTime.isEmpty ? "--" : checkedOutTime,
                              style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              "Check Out",
                              style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Image.asset(AppImage.timeWatch,
                            //     height: size.height * 0.03,
                            //     fit: BoxFit.contain),
                            SizedBox(height: size.height * 0.007),
                            Obx(() => Text(
                                  totalDuration.value.isEmpty
                                      ? "--"
                                      : totalDuration.value,
                                  style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: size.height * 0.005),
                            Text(
                              "Hours",
                              style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                SizedBox(width: size.width * 0.08),
                Text(
                  "Past Attendance List",
                  style: TextStyle(
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
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
            SizedBox(
              height: size.height * .56,
              child: _attendanceList.isEmpty
                  ? const Center(
                      child: Text("No Data Available !"),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          left: size.width * .025,
                          top: size.height * .023,
                          right: size.width * .025),
                      itemCount: _attendanceList.length < 7
                          ? _attendanceList.length
                          : 7,
                      itemBuilder: (context, index) => AttendanceTile(
                        size: size,
                        attendance: _attendanceList[_attendanceList.length < 7
                            ? index
                            : (_attendanceList.length -
                                (_attendanceList.length - 7))],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(Size size, String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black,
          fontSize: size.height * 0.0165,
          fontWeight: FontWeight.w500),
    );
  }

  fetchAllData() async {
    print("fetching all data");
    List<UserInfo> userList = await MyDatabase.getUserInfo('');
    getAttendanceData();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        setState(() {});
      },
    );
    for (var userInfo in userList) {
      print("userData = ${userInfo.toJson()}");
    }
  }
}

startTimer() {
  timer = Timer.periodic(const Duration(minutes: 1), (timer) {
    Duration duration = DateTime.now().difference(checkInDateTime);
    totalDuration.value = "${duration.inHours}h ${duration.inMinutes}m";
    print("time == ${totalDuration.value}");
  });
}

checkInCheckOut(BuildContext context) {
  if (!isCheckedIn) {
    checkedInTime = TimeOfDay.now().format(context).split(" ")[0];
    checkInDateTime = DateTime.now();
    startTimer();
    MyDatabase.addAttendance(Attendance(
            currentUserInfo.name,
            checkedInTime,
            checkedOutTime,
            totalDuration.value,
            DateTime.now().toString().split(" ")[0]))
        .then((value) {
      print("id == $value");
      attendanceId = value;
      getAttendanceData();
    });
  } else {
    checkedOutTime = TimeOfDay.now().format(context).split(" ")[0];
    timer.cancel();
    MyDatabase.updateAttendance(
        Attendance(currentUserInfo.name, checkedInTime, checkedOutTime,
            totalDuration.value, DateTime.now().toString().split(" ")[0]),
        attendanceId);
    getAttendanceData();
    isDone = true;
  }
  isCheckedIn = !isCheckedIn;
}

getAttendanceData() async {
  attendanceList.clear();
  _attendanceList.clear();
  List<Attendance> list = await MyDatabase.getAttendanceList();
  for (var attendance in list) {
    attendanceList.add(attendance);

    if (attendance.name == currentUserInfo.name) {
      _attendanceList.add(attendance);
    }
  }
  print("attendance List = $_attendanceList");
  if (_attendanceList.isNotEmpty) {
    isDone = DateTime.now()
            .difference(DateTime.parse(_attendanceList.last.date))
            .inDays <
        1;
  } else {
    isDone = false;
  }
}
