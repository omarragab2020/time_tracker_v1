import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
//import 'package:user_profile_ii_example/model/user.dart';
//import 'package:user_profile_ii_example/utils/user_preferences.dart';
// import 'package:user_profile_ii_example/widget/appbar_widget.dart';
import 'package:time_tracker/app/screens/profile/views/button_widget.dart';
import 'package:time_tracker/app/screens/profile/views/profile_widget.dart';
import 'package:time_tracker/app/screens/profile/views/textfield_widget.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String firstName = api.first_name;
  String lastName = api.last_name;
  String location = api.location;
  String title = api.title;

  var _image;
  Future getImage() async {
    var x = ImagePicker();
    var image = await x.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await api.uploadImage(_image as File);
    }
  }

  Future downloadImage() async {
    await api.getUserImage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Color.fromARGB(255, 24, 46, 59),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                setState(() {
                  api.profileUpdate = true;
                });
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.grey[200],
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 24, 46, 59), //change your color here
            ),
            title: Text("Profile editing",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Color.fromARGB(255, 24, 46, 59))),
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 35,
              ),
              if (_image != null)
                CircleAvatar(
                    radius: 85,
                    backgroundColor: Color.fromARGB(255, 24, 46, 59),
                    child: ClipOval(
                      child: Image.file(
                        _image as File,
                        fit: BoxFit.fill,
                      ),
                    ))
              else if (api.avatar == "")
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.webp"),
                  radius: 100,
                )
              else
                CircleAvatar(
                  radius: 85,
                  backgroundColor: Color.fromARGB(255, 24, 46, 59),
                  child: ClipOval(
                    child: Image.network(
                      'https://ultimate.abuzeit.com/assets/${api.avatar}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 30.0,
                  color: Colors.grey,
                ),
                onPressed: () {
                  getImage();
                },
              ),
              const SizedBox(height: 10),
              Text("First Name",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              TextFormField(
                initialValue: api.first_name,
                onChanged: (String value) {
                  firstName = value;
                },
              ),
              const SizedBox(height: 10),
              Text("Last Name",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              TextFormField(
                initialValue: api.last_name,
                onChanged: (String value) {
                  lastName = value;
                },
              ),
              const SizedBox(height: 10),
              Text("Title",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              TextFormField(
                initialValue: api.title,
                onChanged: (String value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              Text("E-mail",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              TextFormField(
                initialValue: api.email,
                onChanged: (String value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              Text("Location",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              TextFormField(
                initialValue: api.location,
                onChanged: (String value) {
                  location = value;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () async {
                    Map newProfile = {
                      "first_name": firstName,
                      "last_name": lastName,
                      "title": title,
                      "location": location,
                    };
                    await api.updateProfile(newProfile);
                    setState(() {
                      api.profileUpdate = false;
                    });
                    await api.getUser();

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
