import 'package:flutter/material.dart';

class Utils {
  static final Color? primaryColor = Colors.red[50];
  static final Color? searchbutton = Colors.red[100];
  static final Color sencondaryColor = Color.fromARGB(120, 82, 61, 1);
  static final Color grayColor = Color.fromARGB(92, 161, 161, 137);
}

String formatDate(DateTime date) {
  final month = date.month < 10 ? "0${date.month}" : "${date.month}";
  final day = date.day < 10 ? "0${date.day}" : "${date.day}";
  final fHour = formatHour(date);
  return "$day/$month/${date.year} $fHour";
}

String formatHour(DateTime date) {
  final am = date.hour < 12 ? 'AM' : 'PM';
  final hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
  return "$hour:00 $am";
}

String formatTimestamp(DateTime date) {
  final month = date.month < 10 ? "0${date.month}" : "${date.month}";
  final day = date.day < 10 ? "0${date.day}" : "${date.day}";
  final hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
  final minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";

  return "${date.year}-$month-$day $hour:$minute:00";
}
