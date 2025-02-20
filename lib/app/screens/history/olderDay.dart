import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/screens/history/views/tableAnotherday.dart';
import 'package:time_tracker/app/services/api.dart';

class OlderDay extends StatefulWidget {
  OlderDay({super.key});
  static const routeName = '/olderday';
  static bool intro = true;
  bool loaded = false;
  @override
  State<OlderDay> createState() => _OlderDayState();
}

@override
void initState() {
  //super.initState();
}

class _OlderDayState extends State<OlderDay> {
  late DateTime _selectedDate;
  String chosenDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1).toString();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: const Text("History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.black)),
            centerTitle: true,
          ),
          body: Container(
            color: const Color.fromARGB(255, 24, 46, 59),
            child: Center(
              child: Column(
                children: [
                  const Text(""),
                  const Text(""),
                  const Text(""),
                  const Text(""),
                  const Text(""),

                  if (api.anotherdayupdate) tableAnotherDay(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: Get.width * .75,
                    child: DatePickerWidget(
                      looping: false, // default is not looping
                      firstDate: DateTime(2020, 01, 01),
                      lastDate: DateTime.now(),
                      initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
                      dateFormat: "dd-MMM-yyyy",

                      onChange: (DateTime newDate, _) {
                        chosenDate = DateFormat("yyyy-MM-dd").format(newDate);
                      },
                      pickerTheme: const DateTimePickerTheme(
                        itemTextStyle: TextStyle(color: Colors.black, fontSize: 20),
                        dividerColor: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        // if (chosenDate == "") {
                        //   print("it worked");
                        //   await api.getSpecificEntry(DateTime.now().toString());
                        //   setState(() {
                        //     api.anotherdayupdate = true;
                        //   });
                        // } else
                        if (chosenDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
                          Navigator.pop(context);
                        } else {
                          await api.getSpecificEntry(chosenDate);
                          setState(() {
                            api.anotherdayupdate = true;
                          });
                        }
                      },
                      child: const Text(
                        'Go',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0, color: Colors.white),
                      )),
                  // TextButton(
                  //     onPressed: () {
                  //       DatePicker.showPicker(context, showTitleActions: true,
                  //           onChanged: (date) {
                  //         print('change $date in time zone ' +
                  //             date.timeZoneOffset.inHours.toString());
                  //       }, onConfirm: (date) {
                  //         var formatteddate =
                  //             DateFormat('d:MM:yyyy ').format(date);
                  //         print('confirm $date');
                  //       },
                  //           pickerModel:
                  //               CustomPicker(currentTime: DateTime.now()));
                  //     },
                  // child: Text(
                  //   'Choose the date',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 34.0,
                  //       color: Colors.white),
                  // )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
