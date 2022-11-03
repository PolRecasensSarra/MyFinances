import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  // Decimal precision.
  static int decimalPrecission = 2;
  // List of all filters.
  static List<String> filters = [
    "All",
    "Day",
    "Week",
    "Month",
    "6 months",
    "Year"
  ];

  // Method that given a date time, formats it to day of the week if the date time is inside the current week or the day-month otherwise.
  // @param dateTime String the stored date time.
  static String getFormattedDateTime(String dateTime) {
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
  static Color getColorByEntryValue(double value) {
    return value >= 0.0
        ? const Color.fromARGB(255, 80, 95, 110)
        : const Color.fromARGB(255, 94, 80, 110);
  }

  // Method that checks if the entryDate fits inside the filte.
  static bool filterEntryByDate(String entryDate, String filter) {
    bool returnValue = false;
    DateTime entryDateTime = DateTime.parse(entryDate);
    DateTime currentDateTime = DateTime.now();

    switch (filter) {
      case "All":
        returnValue = true;
        break;
      case "Day":
        returnValue = currentDateTime.difference(entryDateTime).inDays == 0;
        break;
      case "Week":
        int entryWeek = (entryDateTime.day / DateTime.daysPerWeek).ceil();
        int currentWeek = (currentDateTime.day / DateTime.daysPerWeek).ceil();
        returnValue = currentDateTime.month == entryDateTime.month &&
            currentDateTime.year == entryDateTime.year &&
            entryWeek == currentWeek;
        break;
      case "Month":
        returnValue = currentDateTime.month == entryDateTime.month &&
            currentDateTime.year == entryDateTime.year;
        break;
      case "6 months":
        returnValue = currentDateTime.difference(entryDateTime).inDays <=
            DateTime.daysPerWeek * 4 * 6;
        break;
      case "Year":
        returnValue = currentDateTime.year == entryDateTime.year;
        break;
    }
    return returnValue;
  }
}

extension FormatDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
