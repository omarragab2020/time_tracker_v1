import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker/app/screens/auth/dashboard_screen.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:time_tracker/app/screens/profile/views/profile_widget.dart';
import 'package:time_tracker/app/screens/profile/views/edit_profile_page.dart';
import '../../widgets/loading_circle.dart';
import '../auth/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  static const routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const routeName = '/profile';
  String password = "";
  TextEditingController nameController = TextEditingController();

  bool changepass = false;
  Future getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    return user;
  }

  void changepassword() {
    api.changePassword(api.email);
    setState(() {
      changepass = !changepass;
    });
  }

  void confirmDeleteDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        const Text(
                          "Are you sure you want to delete your account?",
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 24, 46, 59),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            child: const Text(
                              "Delete Account",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
                            ),
                            onPressed: () async {
                              if (LoginScreen.isChecked) {
                                SharedPreferences.getInstance().then(
                                  (prefs) {
                                    prefs.setBool("remember_me", false);
                                  },
                                );
                              }
                              await api.deleteAccount();
                              LoginScreen.isChecked = false;
                              api.goToLogin(context);
                              // Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Widget buildName() => Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Text(
                    api.first_name + " " + api.last_name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    api.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    api.location,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    api.email,
                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
          const Text(""),
          const Text(""),
          TextButton(
              onPressed: () {
                setState(() {
                  api.profileUpdate = false;
                });

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: const Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.white),
              )),
          if (!changepass)
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                changepassword();
              },
              child: const Text(
                "Request a password reset",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.white),
              ),
            )
          else
            const Column(
              children: [
                Text(
                  "Check your e-mail for the password reset link (note: you may find it in your spam box)",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(""),
              ],
            ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              if (LoginScreen.isChecked) {
                SharedPreferences.getInstance().then(
                  (prefs) {
                    prefs.setBool("remember_me", false);
                  },
                );
              }
              LoginScreen.isChecked = false;
              api.goToLogin(context);
            },
            child: const Text("Log out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {
              confirmDeleteDialogue();
            },
            child: const Text("Delete Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          ),
        ],
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void startLoading() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (api.profileUpdate == true) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!api.profileUpdate) {
      startLoading();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 46, 59),
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 24, 46, 59), //change your color here
        ),
        title: const Text("My profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Color.fromARGB(255, 24, 46, 59))),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 35,
            ),
            if (api.avatar == "")
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.webp"),
                radius: 100,
              )
            else
              CircleAvatar(
                radius: 85,
                backgroundColor: const Color.fromARGB(255, 24, 46, 59),
                child: ClipOval(
                  child: Image.network(
                    'https://ultimate.abuzeit.com/assets/${api.avatar}',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            const SizedBox(height: 45),
            api.profileUpdate ? buildName() : const LoadingCircle(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
