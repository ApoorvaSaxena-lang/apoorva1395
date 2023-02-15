import 'package:attendence_tracker/Database/database.dart';
import 'package:attendence_tracker/Screens/bottom_bar_screen.dart';
import 'package:attendence_tracker/Screens/profile_screen.dart';
import 'package:attendence_tracker/Utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/user_info.dart';
import 'dashboard_screen.dart';

UserInfo currentUserInfo = UserInfo('', '', '', '', '', '');

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size / 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: size.height * 8,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    size: size.height * 10,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    bool emailValid = emailValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter Email";
                    } else if (!emailValid) {
                      return "Enter valid email";
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordController,
                  obscureText: passToggle,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    bool passwordValid = passwordValidator.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter password";
                    } else if (passwordController.text.length < 8) {
                      return "Password should be more than 8 letter";
                    }
                  },
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: _loginUser,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                        child: const Text(
                          "Sign Up",
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
      ),
    );
  }

  _loginUser() async {
    bool isValidInfo = _formKey.currentState!.validate();
    if (!isValidInfo) {
      return;
    }
    List<UserInfo> userList =
        await MyDatabase.getUserInfo(emailController.text);
    if (userList.isEmpty) {
      if (mounted) {
        showMessage(context, "This email does not exists !");
      }
      return;
    }

    if (userList[0].password != passwordController.text) {
      if (mounted) {
        showMessage(context, "Password is incorrect");
      }
      return;
    }
    currentUserInfo = userList[0];
    emailController.clear();
    passwordController.clear();
    if (mounted) {
      checkedOutTime = '';
      totalDuration.value = '';
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomBarScreen(),
          ),
          (route) => false);
    }
  }
}
