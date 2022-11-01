import 'dart:convert';
import 'dart:io';

import 'package:finance_app/Entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

enum EntryTpe { income, expense }

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final int decimalPrecission = 2;
  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController valueTextCtrl = TextEditingController();
  ScrollController scrollController = ScrollController();
  // List with all the incomes and expenses.
  List<Entry> entryList = [];
  // Used to show an error when adding a new income/expense.
  String error = "";
  // Variables used in the TextField.
  String concept = "";
  double value = 0.0;

  @override
  void initState() {
    parseBalanceFromJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 51, 73),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
          child: Center(
            child: Column(
              children: [
                const Expanded(
                  flex: 10,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Finance App",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                // Balance box.
                Expanded(
                  flex: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Color.fromARGB(255, 135, 30, 233)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Center(
                        child: Text(
                          getFormattedBalance(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // History box.
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "History",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(34, 146, 146, 146),
                            border: Border.all(
                              color: const Color.fromARGB(45, 146, 146, 146),
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: entryList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: const Color.fromARGB(255, 88, 88, 88),
                                  child: ListTile(
                                    title: Text(
                                      entryList[index].concept,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      getFormattedDateTime(
                                          entryList[index].date),
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 180, 180, 180),
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    trailing: Text(
                                      "${entryList[index].value.toPrecision(decimalPrecission)} €",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusColor: getColorByEntryValue(
                                        entryList[index].value),
                                    hoverColor: getColorByEntryValue(
                                        entryList[index].value),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // New entry box.
                Expanded(
                  flex: 35,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "New entry",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        flex: 30,
                        child: TextFormField(
                          controller: nameTextCtrl,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 94, 94, 94),
                            contentPadding:
                                const EdgeInsets.all(8.0), //here your padding
                            hintText: "Add expense or income concept",
                            suffixIcon: const Icon(Icons.text_snippet,
                                color: Colors.white),
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 163, 163, 163),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 146, 146, 146),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 146, 146, 146),
                              ),
                            ),
                          ),
                          validator: (val) =>
                              concept.isEmpty ? "Enter a new entry" : null,
                          onChanged: (val) {
                            setState(() {
                              concept = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        flex: 30,
                        child: TextFormField(
                          controller: valueTextCtrl,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]')),
                          ], // Only numbers can be entered
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 94, 94, 94),
                            contentPadding:
                                const EdgeInsets.all(8.0), //here your padding
                            hintText: "Add expense or income value",
                            suffixIcon: const Icon(Icons.attach_money_outlined,
                                color: Colors.white),
                            alignLabelWithHint: true,
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 163, 163, 163),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 146, 146, 146),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 146, 146, 146)),
                            ),
                          ),
                          validator: (val) =>
                              value == 0.0 ? "Enter a new entry" : null,
                          onChanged: (val) {
                            setState(() {
                              final tmpValue =
                                  val.isEmpty ? 0.0 : double.tryParse(val);
                              if (tmpValue != null) {
                                value = tmpValue;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        flex: 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.blueAccent,
                                  ),
                                ),
                                child: const Text(
                                  "Add income",
                                ),
                                onPressed: () {
                                  updateBalance(EntryTpe.income);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 124, 69, 175),
                                  ),
                                ),
                                child: const Text(
                                  "Add expense",
                                ),
                                onPressed: () {
                                  updateBalance(EntryTpe.expense);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method that updates the current balance.
  void updateBalance(EntryTpe entryType) {
    // Reset the error message.
    error = "";
    // Check that the concept and value are filled.
    if (nameTextCtrl.text.isNotEmpty &&
        (valueTextCtrl.text.isEmpty
                ? 0.0
                : double.tryParse(valueTextCtrl.text))! >
            0.0) {
      // Add a new income to the list. Change the value sign given the entry type.
      double entryValue = value * (entryType == EntryTpe.income ? 1.0 : -1.0);
      entryList.insert(
          0, Entry(concept, entryValue, DateTime.now().toString()));

      // Save the data.
      saveBalanceToJson();

      // Clear the input field texts.
      nameTextCtrl.clear();
      valueTextCtrl.clear();
      concept = "";
      value = 0.0;
    } else {
      error = "Concept and value cannot be null.";
    }
    // Force update the state.
    setState(() {});
  }

  // Method that returns the current balance given the incomes and expenses.
  double getBalance() {
    double balance = 0.0;
    // Iterate the expenses and incomes and add it to the balance.
    for (var entry in entryList) {
      balance += entry.value;
    }
    return balance;
  }

  // Method that returns the formatted balance with the current coin symbol.
  String getFormattedBalance() {
    double balance = getBalance();
    String formattedBalance = "${balance.toPrecision(decimalPrecission)} €";
    return formattedBalance;
  }

  // Method that writes info to the save data file.
  void saveBalanceToJson() async {
    // Get the data file.
    File dataFile = await getSaveDataFile();
    // Encode the entry list as a json string.
    String encodedData = jsonEncode(entryList);
    // Save the data. If the file does not exist, it will be created.
    await dataFile.writeAsString(encodedData);
  }

  // Method that reads from the savedata file.
  void parseBalanceFromJson() async {
    // Clear the entry list to make sure no residual data stays.
    entryList.clear();
    // Get the save data file.
    File dataFile = await getSaveDataFile();
    List<dynamic> jsonData;
    // If the file exists, read it as a String.
    if (await dataFile.exists()) {
      String content = await dataFile.readAsString();
      jsonData = jsonDecode(content);
      // Iterate the jsonData and fill the entry list with the info.
      for (var entry in jsonData) {
        entryList.add(Entry.fromJson(entry));
      }
    }
    // Force update state.
    setState(() {});
  }

  // Method that returns the curent File object fo the save data file.
  Future<File> getSaveDataFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/savedata.save");
  }

  // Return a color depending on if the value is positive or negative.
  Color getColorByEntryValue(double value) {
    return value >= 0.0
        ? const Color.fromARGB(255, 88, 110, 88)
        : const Color.fromARGB(255, 110, 88, 88);
  }

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
        : DateFormat('dd-MM-yyy').add_Hm().format(DateTime.now());
  }

  // Method that shows an alert dialog in order to delete the record history.
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.blueAccent,
        ),
      ),
      child: const Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 175, 69, 69),
        ),
      ),
      child: const Text(
        "Continue",
      ),
      onPressed: () {
        deleteAllHistory();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Delete all history record",
      ),
      content: const Text(
        "Are you sure that you want to delete all the entry history record? This action can't be undone.",
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Method that deletes all the entry history from the save data file.
  void deleteAllHistory() {
    // Clear the entire list.
    entryList.clear();
    // Save the data.
    saveBalanceToJson();
    // Force update state.
    setState(() {});
  }
}

extension FormatDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
