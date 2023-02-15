import 'package:attendence_tracker/Utils/attendance.dart';
import 'package:flutter/material.dart';

class AttendanceTile extends StatelessWidget {
  final Size size;
  final Attendance attendance;

  const AttendanceTile({Key? key, required this.size, required this.attendance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .07,
      margin: EdgeInsets.symmetric(vertical: size.height * .0075),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildText(size, attendance.name),
          _buildText(size, attendance.totalDuration),
          _buildText(size, attendance.date),
          _buildText(size, attendance.checkIn),
          _buildText(size, attendance.checkOut),
        ],
      ),
    );
  }

  Widget _buildText(Size size, String text) {
    return Container(
      width: size.width * 0.17,
      alignment: Alignment.center,
      // color: Colors.green.withOpacity(.1),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black,
            fontSize: size.height * 0.014,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
