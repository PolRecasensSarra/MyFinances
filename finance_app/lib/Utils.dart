import 'dart:io';

import 'package:finance_app/Entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  // Decimal precision.
  final int decimalPrecission = 2;

  // Method that given a date time, formats it to day of the week if the date time is inside the current week or the day-month otherwise.
  // @param dateTime String the stored date time.
  String getFormattedDateTime(String dateTime) {
    // Convert the saved date string to DateTime.
    DateTime givenDate = DateTime.parse(dateTime);
    // Get the current DateTime and get the difference with the given date.
    DateTime now = DateTime.now();
    int difference = now.difference(givenDate).inDays;
    // If the difference if bigger than the days per week, show the date, otherwise show the weekday name and if the difference
    // is 0, set "Today".
    return difference <= DateTime.daysPerWeek
        ? (difference != 0 ? DateFormat.EEEE().format(givenDate) : "Today")
        : DateFormat.yMd(Platform.localeName).add_Hm().format(DateTime.now());
  }

  // Return a color depending on if the value is positive or negative.
  Color getColorByEntryValue(double value) {
    return value >= 0.0
        ? const Color.fromARGB(255, 80, 95, 110)
        : const Color.fromARGB(255, 94, 80, 110);
  }
}

extension FormatDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
