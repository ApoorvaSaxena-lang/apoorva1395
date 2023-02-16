// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:attendence_tracker/Database/database.dart';
import 'package:attendence_tracker/Screens/dashboard_screen.dart';
import 'package:attendence_tracker/Screens/login_screen.dart';
import 'package:attendence_tracker/Screens/signup_screen.dart';
import 'package:attendence_tracker/Utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/user_info.dart';
import 'attendance_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

ImagePicker imagePicker = ImagePicker();

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dob = TextEditingController();
  String imgPath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = currentUserInfo.name;
    email.text = currentUserInfo.email;
    phone.text = currentUserInfo.phone;
    imgPath = currentUserInfo.image;
    dob.text = currentUserInfo.dob;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 100;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 2),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 2.5, right: size.width * 3),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: size.height * 3,
                        )),
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.height * 2.5,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 17.6),
                    height: size.height * 80,
                    width: size.width * 100,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(28))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 30),
                    child: Column(
                      children: [
                        _buildCustomTextField(size, "Full Name", name,
                            keyboardType: TextInputType.text),
                        _buildCustomTextField(size, "Email", email,
                            keyboardType: TextInputType.emailAddress),
                        _buildCustomTextField(size, "Mobile", phone,
                            keyboardType: TextInputType.phone),
                        _buildCustomTextField(
                          size,
                          "Date of Birth",
                          dob,
                          onTap: (context) => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 10),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: size.height * 8,
                      backgroundImage:
                          imgPath.isNotEmpty ? FileImage(File(imgPath)) : null,
                    ),
                  ),
                  Positioned(
                    top: size.height * 20,
                    right: size.width * 31,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                          radius: size.height * 2.5,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.edit,
                            size: size.height * 2.5,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveDetails,
                    child: Container(
                      height: size.height * 7,
                      margin: EdgeInsets.only(
                          left: size.width * 5,
                          right: size.width * 5,
                          top: size.height * 77),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 2.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isCheckedIn) {
                        checkInCheckOut(context);
                      }
                      isDone = false;
                      attendanceList.clear();
                      isCheckedIn = false;

                      checkedInTime = '';
                      checkedOutTime = '';
                      checkInDateTime = DateTime(2023);
                      currentUserInfo = UserInfo('', '', '', '', '', '');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                          (route) => false);
                    },
                    child: Container(
                      height: size.height * 7,
                      margin: EdgeInsets.only(
                          left: size.width * 5,
                          right: size.width * 5,
                          top: size.height * 87),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50)),
                      alignment: Alignment.center,
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 2.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveDetails() async {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        dob.text.isEmpty || imgPath.isEmpty) {
      showMessage(context, "Any of the field above cannot be left empty !");
      return;
    }

    List<UserInfo> userList = await MyDatabase.getUserInfo(email.text);
    if (userList.isNotEmpty && userList[0].email != currentUserInfo.email) {
      if (mounted) {
        showMessage(context, "This email already exists !");
      }
      return;
    }

    if (!nameValidator.hasMatch(name.text)) {
      showMessage(context, "Enter valid name !");
      return;
    }

    if (phone.text.length != 10 || int.tryParse(phone.text) == null) {
      showMessage(context, "Enter valid phone number !");
      return;
    }

    if (!emailValidator.hasMatch(email.text)) {
      showMessage(context, "Enter valid email address !");
      return;
    }

    currentUserInfo = UserInfo(name.text, email.text, phone.text,
        currentUserInfo.password, imgPath, dob.text);

    MyDatabase.updateUserInfo(currentUserInfo);
    showMessage(context, "Information saved successfully");
  }

  _pickImage() async {
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imgPath = xFile.path;
      });
    }
  }

  _selectDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate:
                dob.text.isEmpty ? DateTime.now() : DateTime.parse(dob.text),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101))
        .then((value) {
      if (value != null && value.toString() != dob.text) {
        setState(() {
          dob.text = value.toString().split(" ")[0];
        });
      }
    });
  }

  Widget _buildCustomTextField(
      Size size, String label, TextEditingController textEditingController,
      {Function(BuildContext context)? onTap, TextInputType? keyboardType}) {
    return Container(
      height: size.height * 7,
      margin: EdgeInsets.symmetric(vertical: size.height * 2),
      padding: EdgeInsets.symmetric(horizontal: size.width * 5),
      child: TextField(
        controller: textEditingController,
        readOnly: onTap != null,
        keyboardType: keyboardType,
        onTap: () {
          if (onTap != null) {
            onTap(context);
          }
        },
        maxLength: label == "Mobile" ?10 : null,
        decoration: InputDecoration(
          counterText: '',
            hintStyle: TextStyle(
                color: Colors.black,
                fontSize: size.height * 2,
                fontWeight: FontWeight.w400),
            suffixIcon: label == "Date of Birth"
                ? Icon(
                    Icons.date_range,
                    color: Colors.grey,
                    size: size.height * 3,
                  )
                : null,
            label: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: size.height * 1.5),
            )),
      ),
    );
  }
}

showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
