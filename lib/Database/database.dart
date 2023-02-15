import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/attendance.dart';
import '../Utils/user_info.dart';

const String userInfoTable = 'UserInfo';
const String attendanceTable = 'AttendanceTable';

class MyDatabase {
  static late Database db;

  static Future<void> initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'attendance_tracker.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $userInfoTable (id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, password TEXT, image TEXT, dob TEXT)');
      await db.execute(
          'CREATE TABLE $attendanceTable (id INTEGER PRIMARY KEY, name TEXT, check_in TEXT, check_out TEXT, total_duration TEXT, date TEXT)');
    });
  }

  static Future<List<Attendance>> getAttendanceList() async {
    List<Map> data = await db.query(attendanceTable);

    List<Attendance> attendanceList = [];

    for (var map in data) {
      attendanceList.add(Attendance(map["name"], map["check_in"],
          map["check_out"], map["total_duration"], map["date"]));
    }
    return attendanceList;
  }

  static Future<int> addAttendance(Attendance attendance) async {
    int id = await db.insert(attendanceTable, attendance.toJson());
    return id;
  }

  static Future<int> updateAttendance(
      Attendance attendance, int attendanceId) async {
    int id = await db.update(attendanceTable, attendance.toJson(),
        where: 'id = ?', whereArgs: [attendanceId]);
    return id;
  }

  static Future<List<UserInfo>> getUserInfo(String email) async {
    List<Map> data = await (email.isEmpty
        ? db.query(userInfoTable)
        : db.query(userInfoTable, where: "email = ?", whereArgs: [email]));

    List<UserInfo> userList = [];

    for (var map in data) {
      userList.add(UserInfo(map["name"], map["email"], map["phone"],
          map["password"], map["image"], map['dob']));
    }
    return userList;
  }

  static Future<int> addUserInfo(UserInfo userInfo) async {
    int id = await db.insert(userInfoTable, userInfo.toJson());
    return id;
  }

  static Future<int> updateUserInfo(UserInfo userInfo) async {
    int id = await db.update(userInfoTable, userInfo.toJson(),
        where: 'email = ?', whereArgs: [userInfo.email]);
    return id;
  }
}
