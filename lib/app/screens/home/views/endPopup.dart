import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/api.dart';

class Endpopup extends StatefulWidget {
  const Endpopup({super.key});

  @override
  State<Endpopup> createState() => _EndpopupState();
}

class _EndpopupState extends State<Endpopup> {
  String description = "";
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AlertDialog(
                content: Stack(
                  children: <Widget>[
                    const Text("What did you do in that session?"),
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.close)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              description = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Text("Submit"),
                            onPressed: () {
                              setState(() {
                                api.endempty = false;
                                api.update = false;
                              });
                              api.createEntry(DateFormat('kk:mm:ss').format(DateTime.now()), true, description, false);

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
      },
      child: const Text("End Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0, color: Colors.white)),
    );
  }
}
