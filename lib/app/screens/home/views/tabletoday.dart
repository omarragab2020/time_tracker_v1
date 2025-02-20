import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class tableToday extends StatefulWidget {
  tableToday({super.key});

  @override
  void initState() {
    totalmonth();
  }

  var todaytotal = "";
  List todaySessions = api.today_session;
  List durations = [];
  // List starts = [];
  // List ends = [];
  String totalMonth = "";
  Duration totalM = const Duration(days: 0, hours: 0, minutes: 0);
  Duration totalm = const Duration(days: 0, hours: 0, minutes: 0);
  Duration totalmonth() {
    // Future<String> respon
    // totalMonth = await api.totalMonth() as Duration;
    api.totalMonth().then((value) async {
      setState() {
        totalM = api.durationParse(value as String);
      }

      return totalM;
    });

    return totalM;
  }

  var format = DateFormat("HH:mm");

  List<TableRow> table = [];

  List<TableRow> extract(String totalm) {
    Duration total = const Duration(hours: 0, minutes: 0);
    table.add(const TableRow(children: [Text(" "), Text(" "), Text(" ")]));
    table.add(const TableRow(children: [
      Center(child: Text("Start", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold))),
      Center(child: Text("End ", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold))),
      Center(child: Text("Duration", style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)))
    ]));
    table.add(const TableRow(children: [Text(" "), Text(" "), Text(" ")]));
    for (int i = 0; i < todaySessions.length; i++) {
      // starts.add(
      //     format.format(format.parse(todaySessions[i]["Start"] as String)));
      // try {
      //   ends.add(
      //       format.format(format.parse(todaySessions[i]["End"] as String)));
      // } on Exception catch (exception) {
      //   ends.add(todaySessions[i]["End"]);
      // } catch (error) {
      //   ends.add(todaySessions[i]["End"]);
      // }

      try {
        total = total + (format.parse((todaySessions[i]["End"] as String)).difference(format.parse((todaySessions[i]["Start"] as String))));
        durations.add(format
            .parse((todaySessions[i]["End"] as String))
            .difference(format.parse((todaySessions[i]["Start"] as String)))
            .toString()
            .substring(0, 4));
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        durations.add("");
      } catch (error) {
        // executed for errors of all types other than Exception
        durations.add("");
      }

      /// 3rd elwa2t
      table.add(TableRow(children: [
        Column(children: [
          Text(todaySessions[i]["Start"].toString(), style: const TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.normal))
        ]),
        Column(children: [
          Text(todaySessions[i]["End"].toString(), style: const TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.normal))
        ]),
        Column(children: [
          Text(durations[i].toString(), style: const TextStyle(fontSize: 20.0, color: Color(0xfffe9805), fontWeight: FontWeight.normal))
        ]),
      ]));

      // table.add(Text(
      //   (starts[i].toString() +
      //       "   " +
      //       ends[i].toString() +
      //       "         " +
      //       durations[i].toString()) as String,
      //   style: const TextStyle(
      //       fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.white),
      // ));
    }
    //table.add(Text(" "));
    final String totalString = total.toString().substring(0, 4);

    todaytotal = total.toString().substring(0, 4);

    // table.add(Text(
    //   "Today's total: ${totalString} ",
    //   style: const TextStyle(
    //       fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
    // ));

    //

    table.add(const TableRow(children: [Text(" "), Text(" "), Text(" ")]));

    table.add(
      TableRow(children: [
        const Text(" "),
        const Center(
          child: Text(
            "Today :",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
          ),
        ),
        Center(child: Text(totalString, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Color(0xfffe9805))))
      ]),
    );

    // table.add(TableRow(children: [
    //   Text(""),
    //   Text("This month:",
    //       style: const TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 22.0,
    //           color: Colors.white)),
    //   Text(totalm,
    //       style: const TextStyle(
    //           fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white))
    // ]));
    table.add(const TableRow(children: [Text(" "), Text(" "), Text(" ")]));

    return table;
  }

  @override
  State<tableToday> createState() => _tableTodayState();
}

class _tableTodayState extends State<tableToday> {
  Duration totalM = const Duration(days: 0, hours: 0, minutes: 0);
  Duration totalm = const Duration(days: 0, hours: 0, minutes: 0);

  Duration totalz() {
    api.totalMonth().then((value) {
      setState(() {
        totalM = value as Duration;
      });

      return totalM;
    });
    return totalM;
  }

  void _showDialog() {
    String yesterdayDescription = "";
    String yesterdayEndTime = "00:00";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AlertDialog(
                backgroundColor: Colors.white,
                content: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "You didn't end yesterday's last session which started at ${api.yesterdayStart}, please specify when did it was ended",
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          // width: 300,
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                          child: TimePickerSpinner(
                            time: DateFormat("HH:mm").parse(api.yesterdayStart),
                            alignment: Alignment.center,
                            is24HourMode: true,
                            normalTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
                            highlightedTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                            spacing: 30,
                            itemHeight: 40,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              // print(DateFormat("HH:mm").format(time));
                              yesterdayEndTime = DateFormat("HH:mm").format(time);
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
                            onChanged: (value) {
                              yesterdayDescription = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
                            ),
                            onPressed: () async {
                              if (yesterdayDescription != "") {
                                await api.updateYesterday(yesterdayEndTime, yesterdayDescription);
                                Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    totalz();
    if (api.endEmptyYesterday) {
      Future(_showDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.todaySessions = api.today_session;

    return Container(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(" "),
          Table(defaultColumnWidth: const FixedColumnWidth(90.0), children: tableToday().extract(totalM.toString()) as List<TableRow>),
        ]),
        Text("This Month: ${api.formatDuration(totalM)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white)),
        const Text(""),
      ]),
    );
  }
}
