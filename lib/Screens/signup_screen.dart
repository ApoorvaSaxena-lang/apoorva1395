import 'dart:io';

import 'package:attendence_tracker/Database/database.dart';
import 'package:attendence_tracker/Screens/login_screen.dart';
import 'package:attendence_tracker/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/user_info.dart';
import '../Utils/validator.dart';
import 'dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  String imgPath = '';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkedOutTime = '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 100;

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 100,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: size.height * 8,
                        backgroundImage: imgPath.isNotEmpty
                            ? FileImage(File(imgPath))
                            : null,
                        child: imgPath.isEmpty
                            ? Icon(
                                Icons.person,
                                size: size.height * 10,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    // Positioned(
                    //     top: size.height * 10,
                    //     right: size.width * 32.5,
                    //     child: InkWell(
                    //       onTap: _pickImage,
                    //       child: CircleAvatar(
                    //         backgroundColor: Colors.black.withOpacity(.5),
                    //         radius: size.height * 2,
                    //         child: Icon(
                    //           Icons.edit,
                    //           color: Colors.white,
                    //           size: size.height * 2.5,
                    //         ),
                    //       ),
                    //     ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person), hintText: "Name"),
                  validator: (value) {
                    bool nameValid = nameValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter name";
                    } else if (!nameValid) {
                      return "Enter valid name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.email), hintText: "Email"),
                  validator: (value) {
                    bool emailValid = emailValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter Email";
                    } else if (!emailValid) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  controller: _dob,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_month), hintText: "Dob"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select DOB";
                    } else if (DateTime.parse(_dob.text)
                        .isAfter(DateTime.now())) {
                      return 'Select valid DOB';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  maxLength: 10,
                  controller: _mobileNo,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      counterText: '',
                      icon: Icon(Icons.phone),
                      hintText: "Mobile No."),
                  validator: (value) {
                    bool isMobileValid = phoneValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter mobile no.";
                    } else if (_mobileNo.text.length < 10) {
                      return "Mobile no. should be of 10 digits.";
                    } else if (!isMobileValid) {
                      return "Enter valid mobile number";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock), hintText: "Password"),
                  validator: (value) {
                    bool passwordValid = passwordValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter password";
                    } else if (_password.text.length < 8) {
                      return "Password should be more than 8 letter";
                    } else if (!passwordValid) {
                      return "Your password should contain:\n * 1 special character\n * Lower case\n * Upper case\n * Numbers";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _confirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock), hintText: "Confirm Password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please re-enter the password";
                    } else if (_password.text != _confirmPassword.text) {
                      return "password do not match";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _registerUser,
                child: Container(
                  height: size.height * 6,
                  width: size.width * 60,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  _registerUser() async {
    bool isValidInfo = _formkey.currentState?.validate() ?? false;
    if (!isValidInfo) {
      return;
    }

    // if (imgPath.isEmpty) {
    //   showMessage(context, "Please select the user profile");
    //   return;
    // }
    List<UserInfo> userList = await MyDatabase.getUserInfo(_email.text);
    if (userList.isNotEmpty) {
      if (mounted) {
        showMessage(context, "This email already exists !");
      }
      return;
    }

    try {
      currentUserInfo = UserInfo(_name.text, _email.text, _mobileNo.text,
          _password.text, imgPath, _dob.text);
      await MyDatabase.addUserInfo(currentUserInfo);

      if (mounted) {
        _name.clear();
        _email.clear();
        _mobileNo.clear();
        _password.clear();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
        showMessage(context, "Information added successfully");
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, "Something went wrong");
      }
      return;
    }
  }

  _selectDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate:
                _dob.text.isEmpty ? DateTime.now() : DateTime.parse(_dob.text),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101))
        .then((value) {
      if (value != null && value.toString() != _dob.text) {
        setState(() {
          _dob.text = value.toString().split(" ")[0];
        });
      }
    });
  }

  _pickImage() async {
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imgPath = xFile.path;
      });
    }
  }
}
