import 'package:finance_app/Entry.dart';
import 'package:finance_app/HistoryRecord.dart';
import 'package:finance_app/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Utils.dart';

enum EntryTpe { income, expense }

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController valueTextCtrl = TextEditingController();
  TextEditingController dateController = TextEditingController();
  ScrollController scrollController = ScrollController();
  // List with all the incomes and expenses.
  //List<Entry> entryList = [];
  // Used to show an error when adding a new income/expense.
  String error = "";
  // Variables used in the TextField.
  String concept = "";
  double value = 0.0;
  String date = "";
  // Info Manager instance.
  InfoManager infoManager = InfoManager();

  @override
  void initState() {
    initializeLocale();
    parseBalanceFromJson();
    super.initState();
  }

  // Method to initialize the locales.
  void initializeLocale() async {
    await initializeDateFormatting();
  }

  // Async method to parse all the info.
  void parseBalanceFromJson() async {
    await infoManager.parseBalanceFromJson();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 58, 51, 73),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, bottom: 20.0, top: 20.0),
              child: LimitedBox(
                maxHeight: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(
                      flex: 10,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "My Finances",
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
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "History",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (contextCallback) =>
                                                  HistoryRecordPage(
                                                infoManager: infoManager,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, false);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
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
                                  color:
                                      const Color.fromARGB(45, 146, 146, 146),
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
                                  itemCount: infoManager.entryList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Utils.getColorByEntryValue(
                                          infoManager.entryList[index].value),
                                      child: ListTile(
                                        title: Text(
                                          infoManager.entryList[index].concept,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          Utils.getFormattedDateTime(infoManager
                                              .entryList[index].date),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 180, 180, 180),
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        trailing: Text(
                                          "${infoManager.entryList[index].value.toPrecision(Utils.decimalPrecission)} €",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        focusColor: Utils.getColorByEntryValue(
                                            infoManager.entryList[index].value),
                                        hoverColor: Utils.getColorByEntryValue(
                                            infoManager.entryList[index].value),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        onLongPress: () {
                                          showAlertDialog(context, true,
                                              entry:
                                                  infoManager.entryList[index]);
                                        },
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
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: nameTextCtrl,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 94, 94, 94),
                                contentPadding: const EdgeInsets.all(
                                    8.0), //here your padding
                                hintText: "Add expense or income concept",
                                suffixIcon: const Icon(Icons.text_snippet,
                                    color: Colors.white54),
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 163, 163, 163),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                                fillColor:
                                    const Color.fromARGB(255, 94, 94, 94),
                                contentPadding: const EdgeInsets.all(
                                    8.0), //here your padding
                                hintText: "Add expense or income value",
                                suffixIcon: const Icon(
                                    Icons.attach_money_outlined,
                                    color: Colors.white54),
                                alignLabelWithHint: true,
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 163, 163, 163),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                                      color:
                                          Color.fromARGB(255, 146, 146, 146)),
                                ),
                              ),
                              validator: (val) =>
                                  value == 0.0 ? "Enter a new entry" : null,
                              onChanged: (val) {
                                setState(() {
                                  final tmpValue = val.isEmpty
                                      ? 0.0
                                      : double.tryParse(
                                          val.replaceAll(",", "."));
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
                            child: TextField(
                              cursorColor: Colors.white,
                              controller: dateController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 94, 94, 94),
                                contentPadding: const EdgeInsets.all(
                                    8.0), //here your padding
                                hintText: "Enter Date",
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white54,
                                ),
                                alignLabelWithHint: true,
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 163, 163, 163),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                                      color:
                                          Color.fromARGB(255, 146, 146, 146)),
                                ),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));
                                // Check if the picked date is a valid date and save it.
                                if (pickedDate != null) {
                                  setState(() {
                                    date = pickedDate.toString();
                                    dateController.text =
                                        Utils.getDateFormattedByLocale(
                                            pickedDate,
                                            showHour: false);
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                : double.tryParse(valueTextCtrl.text.replaceAll(",", ".")))! >
            0.0) {
      double entryValue = value * (entryType == EntryTpe.income ? 1.0 : -1.0);
      String entryDate = date.isNotEmpty ? date : DateTime.now().toString();
      // Add a new income to the list. Change the value sign given the entry type.
      infoManager.addNewEntry(Entry(concept, entryValue, entryDate));
      // Save the data.
      infoManager.saveBalanceToJson();

      // Clear the input field texts.
      nameTextCtrl.clear();
      valueTextCtrl.clear();
      dateController.clear();
      concept = "";
      value = 0.0;
      date = "";
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
    for (var entry in infoManager.entryList) {
      balance += entry.value;
    }
    return balance;
  }

  // Method that returns the formatted balance with the current coin symbol.
  String getFormattedBalance() {
    double balance = getBalance();
    String formattedBalance =
        "${balance.toPrecision(Utils.decimalPrecission)} €";
    return formattedBalance;
  }

  // Method that shows an alert dialog in order to delete the record history.
  showAlertDialog(BuildContext context, bool partialDelete, {Entry? entry}) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog(partialDelete, entry: entry);
      },
    );
  }

  // Method that returns an alert dialog depending on if we want to delete an entry or the entire history.
  Widget alertDialog(bool partialDelete, {Entry? entry}) {
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
        if (partialDelete) {
          deleteEntry(entry);
        } else {
          deleteAllHistory();
        }
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        partialDelete ? "Delete entry" : "Delete all history record",
      ),
      content: Text(
        partialDelete
            ? "Are you sure that you want to delete this entry? This action can't be undone."
            : "Are you sure that you want to delete all the entry history record? This action can't be undone.",
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return alert;
  }

  // Method that deletes all the entry history from the save data file.
  void deleteAllHistory() {
    // Clear the entire list.
    infoManager.deleteAllHistory();
    // Force update state.
    setState(() {});
  }

  // Method to delete an entry.
  void deleteEntry(Entry? entry) {
    // Remove the entry.
    infoManager.deleteEntry(entry);
    // Force update state.
    setState(() {});
  }
}
