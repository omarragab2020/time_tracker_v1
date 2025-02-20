import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/services/api.dart';

class tableAnotherDay extends StatefulWidget {
  tableAnotherDay({super.key});

  String todaySessions = api.anotherday_session;
  bool totalavailable = true;

  List durations = [];
  List starts = [];
  List ends = [];

  //tableToday({required this.update});

  var format = DateFormat("HH:mm");

  List<TableRow> table = [];

  List<TableRow> extract() {
    if (todaySessions == "") {
      totalavailable = false;
    }
    Duration total = const Duration(hours: 0, minutes: 0);

    // table.add(TableRow(children: [
    //   Center(
    //       child: Text("Start",
    //           style: TextStyle(
    //               fontSize: 20.0,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold))),
    //   Center(
    //       child: Text("End",
    //           style: TextStyle(
    //               fontSize: 20.0,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold))),
    //   Center(
    //       child: Text("Duration",
    //           style: TextStyle(
    //               fontSize: 20.0,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold)))
    // ]));
    // table.add(TableRow(children: [Text(" "), Text(" "), Text(" ")]));
    // for (int i = 0; i < todaySessions.length; i++) {
    //   starts.add(
    //       format.format(format.parse(todaySessions[i]["Start"] as String)));
    //   try {
    //     ends.add(
    //         format.format(format.parse(todaySessions[i]["End"] as String)));
    //   } on Exception catch (exception) {
    //     ends.add(todaySessions[i]["End"]);
    //   } catch (error) {
    //     ends.add(todaySessions[i]["End"]);
    //   }

    //   // var one = format.parse("10:40");
    //   // var two = format.parse("18:20");
    //   try {
    //     total = total +
    //         (format
    //             .parse((ends[i] as String))
    //             .difference(format.parse((starts[i] as String))));
    //     durations.add(format
    //         .parse((ends[i] as String))
    //         .difference(format.parse((starts[i] as String)))
    //         .toString()
    //         .substring(0, 4));
    //   } on Exception catch (exception) {
    //     // only executed if error is of type Exception
    //     durations.add("");
    //     print("excee0tioonnn");
    //     print(exception);
    //   } catch (error) {
    //     // executed for errors of all types other than Exception
    //     durations.add("");
    //     print("erroor");
    //     print(error);
    //   }

    // table.add(TableRow(children: [
    //   Column(children: [
    //     Text(starts[i].toString(),
    //         style: TextStyle(
    //             fontSize: 20.0,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold))
    //   ]),
    //   Column(children: [
    //     Text(ends[i].toString(),
    //         style: TextStyle(
    //             fontSize: 20.0,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold))
    //   ]),
    //   Column(children: [
    //     Text(durations[i].toString(),
    //         style: TextStyle(
    //             fontSize: 20.0,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold))
    //   ]),
    // ]));
    // table.add(Text(
    //   (starts[i].toString() +
    //       "   " +
    //       ends[i].toString() +
    //       "         " +
    //       durations[i].toString()) as String,
    //   style: const TextStyle(
    //       fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.white),
    // ));
    // }
    //table.add(Text(" "));
    //  final String totalString = total.toString().substring(0, 4);
    // table.add(Text(
    //   "Today's total: ${totalString} ",
    //   style: const TextStyle(
    //       fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
    // ));
    // table.add(TableRow(children: [Text(" "), Text(" "), Text(" ")]));

    table.add(
      TableRow(children: [
        const Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Total work duration:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
            )),
        Padding(
          padding: const EdgeInsets.all(50),
          child: totalavailable
              ? Text(format.format(format.parse(todaySessions)),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white))
              : const Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white)),
          //
        ),
        const Text(" "),
      ]),
    );

    return table;
  }

  @override
  State<tableAnotherDay> createState() => _tableAnotherDayState();
}

class _tableAnotherDayState extends State<tableAnotherDay> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Table(defaultColumnWidth: const FixedColumnWidth(200.0), children: tableAnotherDay().extract() as List<TableRow>));
  }
}
