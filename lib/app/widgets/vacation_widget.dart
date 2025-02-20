import 'package:flutter/material.dart';

Align vacationAlignWidget(String text) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    ),
  );
}

DecoratedBox vacationDays(String text) {
  return DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

InkWell vacationDate(Function()? onTap, String text1, String text2) {
  return InkWell(
    onTap: onTap,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: Colors.green,
      ),
      child: Column(
        children: [
          Text(
            text1,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            text2,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

InkWell applyLeavingButton(Function()? onTap, String text, Color color) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ),
  );
}
