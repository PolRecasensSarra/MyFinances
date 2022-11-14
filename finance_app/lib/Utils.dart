import 'dart:async';
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

    // If the two dates belongs to the same week, show the day of the week or "Today" according to the difference of days.
    // Otherwise show the date.
    return isSameWeek(givenDate, now)
        ? (isSameDay(givenDate, now)
            ? "Today"
            : DateFormat.EEEE().format(givenDate))
        : getDateFormattedByLocale(givenDate);
  }

  // Method that given a DateTime returns a formatted string with the locale format.
  // @param date the current date to format.
  // @param showHour if the hour has to be calculated or not.
  static String getDateFormattedByLocale(DateTime date,
      {bool showHour = true}) {
    DateFormat dateFormat = DateFormat.yMd(Platform.localeName);
    return showHour
        ? dateFormat.add_Hm().format(date)
        : dateFormat.format(date);
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
        returnValue = isSameDay(entryDateTime, currentDateTime);
        break;
      case "Week":
        returnValue = isSameWeek(entryDateTime, currentDateTime);
        break;
      case "Month":
        returnValue = isSameMonth(entryDateTime, currentDateTime);
        break;
      case "6 months":
        returnValue = currentDateTime.difference(entryDateTime).inDays <=
            DateTime.daysPerWeek * 4 * 6;
        break;
      case "Year":
        returnValue = isSameYear(entryDateTime, currentDateTime);
        break;
    }
    return returnValue;
  }

  static String addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  // Method that retuns a TimeOfDay as a String.
  static String timeOfDayToString(TimeOfDay timeOfDay) {
    final String hourLabel = addLeadingZeroIfNeeded(timeOfDay.hour);
    final String minuteLabel = addLeadingZeroIfNeeded(timeOfDay.minute);

    return '$hourLabel:$minuteLabel';
  }

  // Method that returns a DateTime with a given date and time.
  static DateTime addCustomHourToDate(DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour,
        timeOfDay.minute);
  }
}

// Method that returns true if two dates are the same day of the same month and year.
bool isSameDay(DateTime dateA, DateTime dateB) {
  return dateA.day == dateB.day &&
      dateA.year == dateB.year &&
      dateA.month == dateB.month;
}

// Method that returns true if the two dates share the same week of the year and belong to the same year.
bool isSameWeek(DateTime dateA, DateTime dateB) {
  return weekNumber(dateA) == weekNumber(dateB) && isSameYear(dateA, dateB);
}

// Method that returns true if the two dates share the same month of the year and belong to the same year.
bool isSameMonth(DateTime dateA, DateTime dateB) {
  return dateA.month == dateB.month && dateA.year == dateB.year;
}

// Method that returns true if the two dates share the same year.
bool isSameYear(DateTime dateA, DateTime dateB) {
  return dateA.year == dateB.year;
}

/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

extension FormatDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
