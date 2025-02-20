import 'package:flutter/material.dart';
import 'package:time_tracker/app/services/api.dart';

class session extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: api.today_session
              .map((entry) => Row(children: [Text(entry.toString())]))
              .toList()),
    );
  }
}
