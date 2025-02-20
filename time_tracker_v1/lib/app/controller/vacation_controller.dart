import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VacationController extends GetxController {
  Rxn<TimeOfDay> fromTime = Rxn<TimeOfDay>();
  Rxn<TimeOfDay> toTime = Rxn<TimeOfDay>();
  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();
  String statusByDefault = 'Submitted';
  Rxn<Map<String, dynamic>> leaveRequestData = Rxn<Map<String, dynamic>>();
  RxString leaveType = "Annual".obs;
  RxBool isOffice = true.obs;
  RxInt statusValue = 0.obs;
  RxInt remainDays = 0.obs;
  RxInt allowedVacationDays = 0.obs;
  RxList<Map<String, dynamic>> vacationRequests = <Map<String, dynamic>>[].obs;
  RxString userID = ''.obs;
  TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchVacationRequests(userID.value);
    loadUserID();
  }

  Future<void> loadUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userID.value = prefs.getString('userID') ?? '';

    if (userID.value.isNotEmpty) {
      fetchAllowedDays();
      fetchRemainDays(userID.value).then((days) {
        remainDays.value = days;
        update();
        print("🟢 تم تحديث remainDays إلى: $days");
      });
    }
  }

  Future<void> fetchAllowedDays() async {
    int days = await fetchAllowedVacationDays(userID.value);
    allowedVacationDays.value = days;
  }

  // Vacation
  Future<Map<String, dynamic>?> sendRequestVacation(String userID, String leaveType) async {
    if (fromDate.value == null || toDate.value == null) {
      Get.snackbar(
        "Warning",
        "You should choose a date first!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print(" Error: Missing token!");
        return null;
      }

      final url = Uri.parse("https://ultimate.abuzeit.com/items/AnnualLeave");

      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', "Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({
          "userID": userID,
          "from": fromDate.toString(),
          "to": toDate.toString(),
          "Status": statusByDefault,
          "leaveType": leaveType,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Done: Request sent successfully.");
        Get.snackbar(
          "Success",
          "Your request was successfully sent",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        remainDays.value = await fetchRemainDays(userID);
        update();

        fromDate.value = null;
        toDate.value = null;
      } else {
        print("🚨 Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception: $e");
      return null;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchVacationRequests(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) return [];

    final url = Uri.parse("https://ultimate.abuzeit.com/items/AnnualLeave?filter[userID]=$userID");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      final List<Map<String, dynamic>> requests = List<Map<String, dynamic>>.from(responseData["data"]);

      final int approvedCount = requests.where((request) => request['Status'] == "Approved").length;
      remainDays.value = approvedCount;
      remainDays.refresh();
      print(" remainDays updated to: $approvedCount");
      return requests;
    } else {
      return [];
    }
  }

  Future<int> fetchAllowedVacationDays(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print(" Error: Missing token!");
      return 0;
    }

    final url = Uri.parse("https://ultimate.abuzeit.com/items/AnnualLeave?filter[userID]=$userID");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData["data"] is List && responseData["data"].isNotEmpty) {
        return responseData["data"][0]["allowedDays"] ?? 0;
      }
    }

    print(" Error: ${response.body}");
    return 0;
  }

  Future<int> fetchRemainDays(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print("🚨 Error: Missing token!");
      return 0;
    }

    final url = Uri.parse("https://ultimate.abuzeit.com/items/AnnualLeave?filter[userID]=$userID");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      final List<Map<String, dynamic>> requests = List<Map<String, dynamic>>.from(responseData["data"]);

      final int approvedCount = requests.where((request) => request['Status'] == "Approved").length;

      remainDays.value = approvedCount;
      update(); // 🟢 يجبر GetX على تحديث الـ UI
      refresh(); // 🟢 يجبر إعادة بناء الصفحة

      print("✅ remainDays updated to: $approvedCount");
      return approvedCount;
    } else {
      print("🚨 Error: ${response.body}");
      return 0;
    }
  }

  Future<Map<String, dynamic>?> sendRequestLeave(String userID, String descriptionAr) async {
    if (fromTime.value == null || toTime.value == null) {
      Get.snackbar(
        "Warning",
        "You should choose a time first!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print("🚨 Error: Missing token!");
        return null;
      }

      final url = Uri.parse("https://ultimate.abuzeit.com/items/WorkingHours");

      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', "Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({
          "userID": userID,
          "from": formatTimeOfDay(fromTime.value!),
          "to": formatTimeOfDay(toTime.value!),
          "status": statusByDefault,
          "Description_ar": descriptionAr,
        }),
      );

      if (response.statusCode == 200) {
        print(" Done: Request sent successfully.");
        var responseData = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          "Your request was successfully sent",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fromTime.value = null;
        toTime.value = null;
        descriptionController.clear();

        return responseData["data"];
      } else {
        print(
          " Error: ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print(" Exception: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLeaveTimeRequests(String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) return [];

    final url = Uri.parse("https://ultimate.abuzeit.com/items/WorkingHours?filter[userID]=$userID");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(responseData["data"]);
    } else {
      return [];
    }
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    DateTime today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate ? (fromDate.value ?? DateTime.now()) : (toDate.value ?? DateTime.now()),
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (isFromDate) {
        fromDate.value = pickedDate;
      } else {
        toDate.value = pickedDate;
      }
    }
  }

  Future<void> selectTime(BuildContext context, bool isFromTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isFromTime ? (fromTime.value ?? TimeOfDay.now()) : (toTime.value ?? TimeOfDay.now()),
    );

    if (pickedTime != null) {
      if (isFromTime) {
        fromTime.value = pickedTime;
      } else {
        toTime.value = pickedTime;
      }
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Submitted":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(formattedTime);
  }
}
