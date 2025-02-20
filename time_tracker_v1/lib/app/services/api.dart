import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:dio/adapter.dart';

class api {
  var today = "";
  static bool endempty = false;
  bool updateEntry = false;
  static bool sameday = false;
  static int sessions_length = 0;
  static int? AnnualLeave;
  static int? UtilizedAnnualLeave;
  static List today_session = [];
  static String anotherday_session = "";
  static int anotherdaysessions_length = 0;
  static bool anotherdayupdate = false;
  static bool update = false;

  static bool profileUpdate = false;
  static String userID = "";
  static String first_name = "";
  static String last_name = "";
  static String email = "";
  static String location = "";
  static String title = "";
  static String avatar = "";
  static bool endEmptyYesterday = false;
  static String yesterdayStart = "";
  var today_sessions;

  static get contentType => null;

  static String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    //  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  static Future<void> refresh() async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.headers['Content-Type'] = 'application/json';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response response = await dio.post(
        'https://ultimate.abuzeit.com/auth/refresh',
        data: {"refresh_token": prefs.getString('refresh_token'), "mode": "json"},
      );

      var server_json = jsonDecode(response.toString());
      var token = server_json['data']['access_token'];
      var refresh_token = server_json['data']['refresh_token'];
      prefs.setString('token', token as String);
      prefs.setString('refresh_token', refresh_token as String);
    } catch (error, stackTrace) {}
  }

  static Future<bool> goToLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response response = await dio.post('https://ultimate.abuzeit.com/auth/logout', data: {'refresh_token': prefs.getString('refresh_token')});
      update = false;
      //var server_json = jsonDecode(response.toString());
      // print(server_json);
      Navigator.of(context).pushReplacementNamed('/auth').then((_) => false);
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }

  static Future<String?> signupUser(SignupData data) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers = {'Content-Type': 'application/json'};
    try {
      Response response = await dio.post(
        'https://ultimate.abuzeit.com/users',
        data: {"email": data.name, "password": data.password, "role": "2dd7f654-e3af-440a-8853-347a46f58d7b"},
      );
    } catch (error, stackTrace) {
      return (error.toString());
    }
  }

  static Future<String?> loginUser(LoginData data) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';

    try {
      Response response = await dio.post('https://ultimate.abuzeit.com/auth/login', data: {"email": data.name, "password": data.password});

      var server_json = jsonDecode(response.toString());
      var token = server_json['data']['access_token'];
      var refresh_token = server_json['data']['refresh_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token as String);
      prefs.setString('refresh_token', refresh_token as String);
      String user = await getUser();
      prefs.setString('userID', user);
    }
    // } catch (DioErrorType) {
    //   print(DioErrorType.toString());
    //   return (DioErrorType.toString());
    catch (error, stackTrace) {
      return ("Incorrect e-mail or password");
    }
    return null;
  }

  static Future<String> createEntry(var startTime, bool end, String description, bool workLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    var today = DateFormat('yyyy-MM-dd').format(now);
    var lastEntry = await getLastEntry();
    if (!end) {
      if (await isupdate() == true) {
        await updateStart(DateFormat('HH:mm').format(DateTime.now()), lastEntry, workLocation);

        endempty = true;
      } else {
        await createNew(today, startTime, workLocation);
        endempty = true;
      }
    } else {
      var ending = await updateEnd(startTime, lastEntry, description);
      if (ending == "endtime error") {
        await isupdate();
        return "endtime error";
      }
    }
    await isupdate();
    return "success";
  }

  static Future<String?> createNew(String today, var startTime, bool workLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    update = false;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    try {
      Response response = await dio.post(
        'https://ultimate.abuzeit.com/items/time_tracker/',
        data: {
          "date": today,
          "Startx": [
            {"Start": startTime, "End": "     ", "Office": workLocation},
          ],
        },
      );
      await api.start();
    } catch (error, stackTrace) {}
    return null;
  }

  static Future<String?> updateStart(var startTime, lastEntry, bool workLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    var id = lastEntry['id'];
    //print(lastEntry);
    List startx = lastEntry['Startx'] as List;
    startx.add({"Start": startTime, "End": "     ", "Office": workLocation});
    today_session = startx as List;
    sessions_length = startx.length;
    update = true;

    try {
      Response response = await dio.patch('https://ultimate.abuzeit.com/items/time_tracker/${id}', data: {"Startx": startx});
    } catch (error, stackTrace) {}
    return null;
  }

  static Duration durationParse(String s) {
    int hours = 0;
    int minutes = 0;

    List<String> parts = s.split(':');
    if (parts.length > 1) {
      hours = int.parse(parts[parts.length - 2]);
    }
    if (parts.length > 0) {
      minutes = int.parse(parts[parts.length - 1]);
    }

    return Duration(hours: hours, minutes: minutes);
  }

  static Future<String?> updateEnd(var endTime, lastEntry, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    var id = lastEntry['id'];
    Duration total = Duration.zero;
    var format = DateFormat("HH:mm");
    if (lastEntry["total"] != null) {
      total = durationParse(lastEntry["total"] as String);

      // total = format.format(format.parse(lastEntry["total"] as String));
    }

    var startx = lastEntry['Startx'] as List;
    int startxindex = startx.length;
    startx[startxindex - 1]["End"] = endTime;
    startx[startxindex - 1]["description"] = description;

    Duration duration = format.parse((endTime as String)).difference(format.parse((startx[startxindex - 1]["Start"] as String)));
    if (duration < const Duration(days: 0, hours: 0, minutes: 0)) {
      return "endtime error";
    }
    total = total + duration;

    try {
      Response response = await dio.patch(
        'https://ultimate.abuzeit.com/items/time_tracker/${id}',
        data: {
          "total": (formatDuration(total)),
          //
          "Startx": startx,
        },
      );
    } catch (error, stackTrace) {}
    return null;
  }

  static Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    String user;

    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/users/me');
      var server_json = jsonDecode(response.toString());
      user = server_json['data']['id'] as String;
      // prefs.setString('user', server_json['data'].toString());
      try {
        AnnualLeave = server_json['data']["AnnualLeave"] as int?;
      } catch (e) {
        AnnualLeave = 0;
      }
      try {
        UtilizedAnnualLeave = server_json['data']["UtilizedAnnualLeave"] as int?;
      } catch (e) {
        UtilizedAnnualLeave = 0;
      }
      try {
        userID = server_json['data']["id"] as String;
      } catch (e) {
        first_name = "unknown";
      }
      try {
        first_name = server_json['data']["first_name"] as String;
      } catch (e) {
        first_name = "unknown";
      }

      try {
        last_name = server_json['data']["last_name"] as String;
      } catch (e) {
        last_name = "unknown";
      }

      try {
        email = server_json['data']["email"] as String;
      } catch (e) {
        email = "unknown";
      }

      try {
        location = server_json['data']["location"] as String;
      } catch (e) {
        location = "unknown";
      }

      try {
        title = server_json['data']["title"] as String;
      } catch (e) {
        title = "unknown";
      }
      try {
        avatar = server_json['data']["avatar"] as String;
      } catch (e) {
        avatar = "unknown";
      }
      profileUpdate = true;
      return user;
    } catch (error, stackTrace) {
      return ("Exception occurred: $error  stackTrace: $stackTrace");
    }
  }

  static Future<Map> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    String user;

    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/users/me');
      // var server_json = jsonDecode(response.toString());
      Map server_json = jsonDecode(response.toString()) as Map;
      // user = server_json['data']['id'] as String;
      return server_json;
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    String user;

    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/users/me');
      // var server_json = jsonDecode(response.toString());
      Map server_json = jsonDecode(response.toString()) as Map;
      var image = server_json['data']['avatar'];
      return image;
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future getLastEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;

    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;

    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/items/time_tracker?filter[user_created][_eq]=${user}&sort=-id&limit=1');
      var server_json = jsonDecode(response.toString());
      if (server_json['data'].length == 0) {
        return null;
      } else {
        last_session = server_json['data'][0];
        return last_session;
      }
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future getSpecificEntry(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    // dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;

    try {
      Response response = await dio.get(
        'https://ultimate.abuzeit.com/items/time_tracker?fields=total&filter[user_created][_eq]=${user}&filter[date][_eq]=${date}&sort=-id&limit=1',
      );

      var server_json = jsonDecode(response.toString());
      if ((server_json['data'] as List).length == 0) {
        anotherday_session = "";
      } else {
        anotherday_session = server_json['data'][0]['total'] as String;
      }
      anotherdaysessions_length = anotherday_session.length;
      StepState() {
        anotherdayupdate = true;
      }

      if (server_json['data'].length == 0) {
        return "";
      } else {
        last_session = server_json['data'][0];
        return last_session;
      }
    } catch (RangeError) {
      return null;
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future updateYesterday(String endtime, String description) async {
    var last = await api.getLastEntry();
    await updateEnd(endtime, last, description);
    endEmptyYesterday = false;
  }

  static Future<String?> getLastEntryID() async {
    var last = await api.getLastEntry();
    var id = last['id'];
    return id?.toString() ?? '';
  }

  static Future isendempty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    var today = DateFormat('yyyy-MM-dd').format(now);

    var last_session;
    var last = await api.getLastEntry();
    if (last == null) {
      endempty = false;
    } else {
      var today_sessions = last['Startx'] as List;
      var indexlast = today_sessions.length;
      last_session = today_sessions[indexlast - 1];

      if (last_session['End'] == "     ") {
        endempty = true;
        final yesterday = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day - 1));
        if (last['date'] != today) {
          endempty = false;
          if (last['date'] == yesterday) {
            yesterdayStart = last_session['Start'] as String;
            endEmptyYesterday = true;
          }
        }
      } else {
        endempty = false;
      }
    }
  }

  static Future start() async {
    await api.isendempty();
    await api.isupdate();
  }

  static Future totalMonth() async {
    DateTime now = DateTime.now();
    DateTime required = DateTime(now.year, now.month, 1);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    Duration totalMonth = const Duration();
    try {
      Response response = await dio.get(
        'https://ultimate.abuzeit.com/items/time_tracker?fields=total&filter[user_created][_eq]=${user}&filter[date][_gte]=${required.toString()}',
      );

      var server_json = jsonDecode(response.toString());
      if ((server_json['data'] as List).length == 0) {
        anotherday_session = "";
      } else {
        var monthEntries = (server_json['data'] as List);
        for (int i = 0; i < monthEntries.length; i++) {
          if (monthEntries[i]['total'] != null) {
            totalMonth = totalMonth + (durationParse(monthEntries[i]['total'] as String));
          }
        }
      }
      return (totalMonth);
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future isupdate() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    var today = DateFormat('yyyy-MM-dd').format(now);
    var todayentry;

    todayentry = await getLastEntry();
    if (todayentry == null) {
    } else {
      todayentry = todayentry as Map;
    }

    if (todayentry == null) {
      sessions_length = 0;
      today_session = [];
      sameday = false;
      update = true;
      return null;
    } else if (todayentry['date'] == today) {
      today_session = todayentry['Startx'] as List;
      sessions_length = today_session.length;
      sameday = true;

      update = true;

      return true;
    } else {
      sessions_length = 0;
      today_session = [];
      sameday = false;
      update = true;
      return false;
    }
  }

  static Future changePassword(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    // dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;

    try {
      Response response = await dio.post('https://ultimate.abuzeit.com/auth/password/request', data: {"email": email});
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future getTotalMonth(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;

    try {
      Response response = await dio.get(
        'https://ultimate.abuzeit.com/items/time_tracker?filter[user_created][_eq]=${user}&filter[date][_>]=${date}&sort=-id&limit=1',
      );

      var server_json = jsonDecode(response.toString());

      anotherday_session = server_json['data'][0]['total'] as String;
      anotherdaysessions_length = anotherday_session.length;
      SetState() {
        anotherdayupdate = true;
      }

      if (server_json['data'].length == 0) {
        return null;
      } else {
        last_session = server_json['data'][0];
        return last_session;
      }
    } catch (error, stackTrace) {
      return {};
    }
  }

  static Future<void> updateProfile(Map profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;
    try {
      Response response = await dio.patch('https://ultimate.abuzeit.com/users/me', data: profile);

      var server_json = jsonDecode(response.toString());
      anotherday_session = server_json['data'][0]['total'] as String;
      anotherdaysessions_length = anotherday_session.length;

      if (server_json['data'].length == 0) {
        return null;
      } else {
        last_session = server_json['data'][0];
        return last_session;
      }
    } catch (error, stackTrace) {}
  }

  static Future<void> uploadImage(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({"file": await MultipartFile.fromFile(file.path, filename: fileName)});

    try {
      Response response = await dio.post('https://ultimate.abuzeit.com/files', data: formData);

      var server_json = jsonDecode(response.toString());

      if (server_json['data'].length == 0) {
        return null;
      } else {
        prefs.setString("avatar", server_json['data']['id'] as String);
        updateProfile({"avatar": server_json['data']['id'] as String});
      }
    } catch (error, stackTrace) {}
  }

  static Future<void> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //dio.options.headers['Content-Type'] = 'application/json';
    // dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    try {
      List records = await getAllRecords();
      await deleteUserRecords(records);
      List images = await getAllImages();
      await deleteAllimages(images);
      print("userrrr");
      print(user);
      Response response = await dio.delete('https://ultimate.abuzeit.com/users/${user}');
      //var server_json = jsonDecode(response.toString());
      //print(server_json);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}

Future<List> getAllRecords() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String user = prefs.getString('userID')!;
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  };
  //dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

  try {
    Response response = await dio.get('https://ultimate.abuzeit.com/items/time_tracker?filter[user_created][_eq]=${user}&fields=id');

    if (response.statusCode == 200) {
      List ids = [];
      for (var item in response.data["data"]) {
        ids.add(item["id"]);
      }
      print(ids);
      return ids;
    } else {
      print(response.statusMessage);
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List> getAllImages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = await prefs.getString('userID') as String;
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  };
  //dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

  try {
    Response response = await dio.get('https://ultimate.abuzeit.com/files?filter[uploaded_by][_eq]=${user}&fields=id');

    if (response.statusCode == 200) {
      List ids = [];
      for (var item in response.data["data"]) {
        ids.add(item["id"].toString());
      }
      print(ids);
      return ids;
    } else {
      print(response.statusMessage);
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<void> deleteAllimages(List records) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = await prefs.getString('userID') as String;
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  };
  //dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

  try {
    print(records);
    print("deleting user images");
    Response response = await dio.delete('https://ultimate.abuzeit.com/files/', data: json.encode(records));
    print("done deleting user images");
    // var server_json = jsonDecode(response.toString());
    // print(server_json);
    print(json.encode(records));

    //var server_json = jsonDecode(response.toString());
    // print(server_json);
  } catch (error, stackTrace) {
    print("errorrrrssfdfe");
    print(error);
    print(stackTrace);
  }
}

Future<void> deleteUserRecords(List records) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = await prefs.getString('userID') as String;
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  };
  //dio.options.headers['Content-Type'] = 'application/json';
  // dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

  try {
    print(records);
    print("deleting user recorddssss");
    Response response = await dio.delete('https://ultimate.abuzeit.com/items/time_tracker/', data: json.encode(records));
    print("done deleting user recorddssss");
    // var server_json = jsonDecode(response.toString());
    // print(server_json);
    print(records);
    print(json.encode(records));

    //var server_json = jsonDecode(response.toString());
    // print(server_json);
  } catch (error, stackTrace) {
    print("errorrrrssfdfe");
    print(error);
    print(stackTrace);
  }
}
