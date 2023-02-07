import 'package:finance_app/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'Entry.dart';
import 'Utils.dart';

enum EntryTpe { income, expense }

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController valueTextCtrl = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  // Used to show an error when adding a new income/expense.
  String error = "";
  // Variables used in the TextField.
  String concept = "";
  double value = 0.0;
  String date = "";
  TimeOfDay timeOfDay = TimeOfDay.now();
  // Selected category for the entry.
  Categories selectedCategory = Categories.others;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText("tr_my_finances"),
        backgroundColor: const Color.fromARGB(255, 39, 41, 43),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 29, 31, 33),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 20.0, top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: LocaleText(
                      "tr_add_new_entry",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  TextFormField(
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
                      hintText: Locales.string(
                          context, "tr_new_entry_expense_concept"),
                      suffixIcon:
                          const Icon(Icons.text_snippet, color: Colors.white54),
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
                  const SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    controller: valueTextCtrl,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ], // Only numbers can be entered
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 94, 94, 94),
                      contentPadding:
                          const EdgeInsets.all(8.0), //here your padding
                      hintText:
                          Locales.string(context, "tr_new_entry_expense_value"),
                      suffixIcon:
                          const Icon(Icons.euro_symbol, color: Colors.white54),
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
                        final tmpValue = val.isEmpty
                            ? 0.0
                            : double.tryParse(val.replaceAll(",", "."));
                        if (tmpValue != null) {
                          value = tmpValue;
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: dateController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 94, 94, 94),
                            contentPadding:
                                const EdgeInsets.all(8.0), //here your padding
                            hintText: Locales.string(
                                context, "tr_new_entry_enter_date"),
                            suffixIcon: const Icon(
                              Icons.calendar_month,
                              color: Colors.white54,
                            ),
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
                                    Utils.getDateFormattedByLocale(pickedDate,
                                        showHour: false);
                              });
                            }
                          },
                        ),
                      ),
                      const Expanded(
                        flex: 5,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 45,
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: timeController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 94, 94, 94),
                            contentPadding: const EdgeInsets.all(8.0),
                            hintText: Locales.string(
                                context, "tr_new_entry_enter_time"),
                            suffixIcon: const Icon(
                              Icons.access_time,
                              color: Colors.white54,
                            ),
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
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            // Check if the picked date is a valid date and save it.
                            if (pickedTime != null) {
                              setState(() {
                                timeOfDay = pickedTime;
                                timeController.text =
                                    Utils.timeOfDayToString(pickedTime);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 94, 94, 94),
                            border: Border.all(
                              color: const Color.fromARGB(45, 146, 146, 146),
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: DropdownButton<Categories>(
                                value: selectedCategory,
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (Categories? value) {
                                  setState(() {
                                    selectedCategory = value!;
                                  });
                                },
                                items: Categories.values
                                    .map((Categories category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: LocaleText(
                                      category.name,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 45,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: LocaleText(
                            "tr_new_entry_category",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 206, 206, 206),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 94, 128, 95),
                            ),
                          ),
                          child: const LocaleText(
                            "tr_new_entry_add_income",
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
                              const Color.fromARGB(255, 146, 101, 101),
                            ),
                          ),
                          child: const LocaleText(
                            "tr_new_entry_add_expense",
                          ),
                          onPressed: () {
                            updateBalance(EntryTpe.expense);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  getErrorLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getErrorLabel() {
    Widget result = const Text("");
    if (error.isEmpty) {
      result = Text(
        error,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      );
    } else {
      result = LocaleText(
        error,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      );
    }
    return result;
  }

  // Method that updates the current balance.
  void updateBalance(EntryTpe entryType) {
    // Reset the error message.
    error = "";
    bool validEntry = false;
    // Check that the concept and value are filled.
    if (nameTextCtrl.text.isNotEmpty &&
        (valueTextCtrl.text.isEmpty
                ? 0.0
                : double.tryParse(valueTextCtrl.text.replaceAll(",", ".")))! >
            0.0) {
      double entryValue = value * (entryType == EntryTpe.income ? 1.0 : -1.0);
      // If the selected date is valid, add it with the selected time. Otherwise set the current time. If the date is valid
      // but the hour was not picked, get the current time.
      String entryDate = date.isNotEmpty
          ? Utils.addCustomHourToDate(DateTime.parse(date),
                  timeController.text.isNotEmpty ? timeOfDay : TimeOfDay.now())
              .toString()
          : DateTime.now().toString();

      // Add a new income to the list. Change the value sign given the entry type.
      InfoManager.get.addNewEntry(
          Entry(concept, entryValue, entryDate, selectedCategory.index));
      // Save the data.
      InfoManager.get.saveBalanceToJson();

      // Clear the input field texts.
      nameTextCtrl.clear();
      valueTextCtrl.clear();
      dateController.clear();
      timeController.clear();
      concept = "";
      value = 0.0;
      date = "";
      validEntry = true;
    } else {
      error = "tr_new_entry_error_text";
    }
    // Force update the state.
    setState(() {});
    // Pop this screen if the entry was correctly added.
    if (validEntry) {
      InfoManager.get.updateEntries(ViewTypes.all);
      Navigator.pop(context);
    }
  }
}
