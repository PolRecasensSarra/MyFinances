import 'dart:io';
import 'package:finance_app/Filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  // Decimal precision.
  static int decimalPrecission = 2;
  static List<String> filters = [
    "All",
    "Day",
    "7 days",
    "Week",
    "Month",
    "6 months",
    "12 months",
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

  // Method that returns the list of filters as Filter class.
  static List<Filter> getFilters() {
    List<Filter> filtersList = [];
    for (String filterStr in filters) {
      filtersList.add(Filter(filterStr));
    }
    return filtersList;
  }

  // List that returns a list of drop down menu items given a filter list.
  /*List<DropdownMenuItem<Filter>> getFiltersAsItemsList() {
    List<DropdownMenuItem<Filter>> listItems = [];
    for (Filter filter in getFilters()) {
      listItems.add(DropdownMenuItem<Filter>(
        value: filter,
        child: Text(filter.filterName),
      ));
    }
    return listItems;
  }*/
}

extension FormatDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
