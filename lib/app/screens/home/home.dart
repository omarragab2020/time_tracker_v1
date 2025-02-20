import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/controller/vacation_controller.dart';
import 'package:time_tracker/app/screens/history/olderDay.dart';
import 'package:time_tracker/app/screens/home/views/tabletoday.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:time_tracker/app/widgets/loading_circle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // var startTime;
  bool canShowButton = true;

// Create instance.
  void startLoading() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (api.update == true) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  DateTime refresh = DateTime.now();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('HH:mm   EEE d MMM ').format(DateTime.now());

  void showEndErrorDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      "Please make sure the session's end time is not earlier than the start time",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 24, 46, 59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Dismiss",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEndEarlierTimeDialog() {
    String description = "";
    String endTime = "00:00";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 24, 46, 59),
                                ),
                              ),
                            )),
                        Padding(
                          // width: 300,
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                          child: TimePickerSpinner(
                            time: DateTime.now(),
                            alignment: Alignment.center,
                            is24HourMode: true,
                            normalTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
                            highlightedTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                            spacing: 30,
                            itemHeight: 40,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              // print(DateFormat("HH:mm").format(time));
                              endTime = DateFormat("HH:mm").format(time);
                            },
                          ),
                        ),
                        const Text(
                          "What did you do in that session?",
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            maxLines: 2,
                            onChanged: (value) {
                              description = value;
                            },
                          ),
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
                              "Submit",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
                            ),
                            onPressed: () async {
                              if (description != "") {
                                if (description != "") {
                                  setState(() {
                                    api.endempty = false;
                                    api.update = false;
                                  });
                                  var ending = await api.createEntry(
                                    endTime,
                                    true,
                                    description,
                                    controller.isOffice.value,
                                  );

                                  if (ending == "endtime error") {
                                    //Navigator.of(context).pop();
                                    showEndErrorDialogue();
                                  } else {
                                    description = "";
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
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

  void showEndChoicesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            child: Column(children: [
              Row(children: [
                const Text("End Time with:",
                    textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black)),
                const SizedBox(
                  width: 20,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 24, 46, 59),
                        ),
                      ),
                    )),
              ]),
              const SizedBox(
                height: 20,
              ),
              Row(children: <Widget>[
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 24, 46, 59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEndNowDialog();
                    },
                    child: const SizedBox(
                      // width: 75,
                      child: Text("Current",
                          textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 24, 46, 59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showEndEarlierTimeDialog();
                    },
                    child: Container(
                        // width: 70,
                        child: const Text("Earlier",
                            textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)))),
              ])
            ]),
          ),
        );
      },
    );
  }

  void _showEndNowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: const Alignment(1, -1),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 25,
                        color: Color.fromARGB(255, 24, 46, 59),
                      ),
                    ),
                  ),
                ),
                const Text(
                  "What did you do in that session?",
                  // textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    maxLines: 2,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
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
                      "Submit",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
                    ),
                    onPressed: () {
                      if (description != "") {
                        setState(() {
                          api.endempty = false;
                          api.update = false;
                        });
                        api.createEntry(
                          DateFormat('HH:mm').format(DateTime.now()),
                          true,
                          description,
                          controller.isOffice.value,
                        );
                        description = "";
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    // loadSwitchState();
    // loadSwitchVacationState();
    time();
    // if (api.endEmptyYesterday) {
    //   Future(_showDialog);
    // }
  }

  void time() {
    Timer.periodic(const Duration(seconds: 61), (timer) async {
      if (mounted) {
        setState(() {
          formattedDate = DateFormat('HH:mm  EEE d MMM ').format(DateTime.now());
        });

        if (DateFormat('HH:mm').format(DateTime.now()) == "00:01") {
          api.update = false;

          await api.start();
        }

        // print("difference");
        //   print(DateTime.now().difference(refresh));
        if (DateTime.now().difference(refresh) > const Duration(minutes: 15)) {
          api.refresh();
          refresh = DateTime.now();
        }
      }
    });
  }

  // void loadSwitchState() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     switching = prefs.getBool('RemoteWork') ?? false;
  //   });
  // }
  //
  // void saveSwitchState(bool value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('RemoteWork', value);
  // }

  // Future<void> sendToggleSwitch(bool value) async {
  //   setState(() {
  //     controller.isOffice.value = value;
  //   });
  //   // saveSwitchState(value);
  //   await api.refresh();
  //   await api.sendSwitchState(state: value);
  // }

  String description = "";
  bool workLocation = true;

  // bool switching = true;
  TimeOfDay? selectedTimeTo;
  TimeOfDay? selectedTimeFrom;
  final controller = Get.find<VacationController>();

  Widget build(BuildContext context) {
    if (!api.update) {
      startLoading();
    }

    Theme.of(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 24, 46, 59),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
                ),
                Row(children: [
                  const Text(
                    'Office',
                    style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  // const Spacer(),
                  Obx(() {
                    return Switch(
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        activeTrackColor: Colors.lightGreen,
                        inactiveTrackColor: Colors.grey,
                        value: controller.isOffice.value,
                        onChanged: (value) {
                          controller.isOffice.value = value;
                        });
                  }),
                ]),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: api.update ? tableToday() : const LoadingCircle(),
                ),
                const SizedBox(height: 10),

                TextButton(
                    onPressed: () {
                      setState(() {
                        api.update = false;
                      });
                      api.start();
                    },
                    child: Container(
                      width: 100,
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text("Refresh ", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                        Icon(
                          FontAwesomeIcons.arrowsRotate,
                          color: Colors.white,
                        )
                      ]),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OlderDay()));
                    },
                    child: const Text("Go to an older date > ", style: TextStyle(fontSize: 18.0, color: Colors.white))),
                if (!api.endempty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          // toggleSwitchVacation(vacation);
                          // sendToggleSwitch(switching);
                          api.createEntry(
                            DateFormat('HH:mm').format(DateTime.now()),
                            false,
                            " - ",
                            controller.isOffice.value,
                          );

                          setState(() {
                            api.endempty = true;
                            api.update = false;
                          });
                        },
                        child: const Text(
                          "Start Session",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          showEndChoicesDialog();
                        },
                        child: const Text("End Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white)),
                      ),
                    ),
                  ),
                // TextButton(
                //     onPressed: () {
                //       Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                //     },
                //     child: Text("chat")),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
