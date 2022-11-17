import 'package:finance_app/Entry.dart';
import 'package:finance_app/NewEntryPage.dart';
import 'package:finance_app/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'Utils.dart';

// Enum with the different view types.
enum ViewTypes { all, income, expense }

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  ScrollController scrollController = ScrollController();

  // Enum variable that indicates the view type.
  ViewTypes _selectedViewType = ViewTypes.all;
  // Local entry list modified by the view selected type.
  List<Entry> entryListByView = [];
  // Get the list of filters.
  List<String> filterList = Utils.filters;
  // Filter selected by the drop down menu.
  late String filterSelected = filterList.first;

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
    // Force update view type.
    updateEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Finances"),
        backgroundColor: const Color.fromARGB(255, 39, 41, 43),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 29, 31, 33),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: const Color.fromARGB(255, 120, 187, 255),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 39, 41, 43),
        items: const [
          BottomNavigationBarItem(
            label: "Show All",
            icon: Icon(
              Icons.savings,
            ),
          ),
          BottomNavigationBarItem(
            label: "Show Incomes",
            icon: Icon(
              Icons.paid,
            ),
          ),
          BottomNavigationBarItem(
            label: "Show Expenses",
            icon: Icon(
              Icons.payments,
            ),
          ),
        ],
        currentIndex: _selectedViewType.index,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 15.0, top: 20.0),
            child: Column(
              children: [
                // Balance box.
                Expanded(
                  flex: 21,
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
                const Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: dropDownFilters(),
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
                ),
                const Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                // History box.
                Expanded(
                  flex: 55,
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
                        itemCount: entryListByView.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Utils.getColorByEntryValue(
                                entryListByView[index].value),
                            child: ListTile(
                              title: Text(
                                entryListByView[index].concept,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                Utils.getFormattedDateTime(
                                    entryListByView[index].date),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 180, 180, 180),
                                  fontSize: 10.0,
                                ),
                              ),
                              trailing: Text(
                                "${entryListByView[index].value.toPrecision(Utils.decimalPrecission)} €",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              focusColor: Utils.getColorByEntryValue(
                                  entryListByView[index].value),
                              hoverColor: Utils.getColorByEntryValue(
                                  entryListByView[index].value),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onLongPress: () {
                                showAlertDialog(context, true,
                                    entry: entryListByView[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 89, 138, 187),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (contextCallback) => NewEntryPage(
                            infoManager: infoManager,
                          ),
                        ),
                      )
                          .then((_) {
                        setState(() {
                          // Update the entries when the entry page pops.
                          updateEntries();
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method that returns the current balance given the incomes and expenses and filters.
  double getBalance() {
    double balance = 0.0;
    // Iterate the expenses and incomes and add it to the balance.
    for (var entry in entryListByView) {
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
    setState(() {
      updateEntries();
    });
  }

  // Method to delete an entry.
  void deleteEntry(Entry? entry) {
    // Remove the entry.
    infoManager.deleteEntry(entry);
    // Force update state.
    setState(() {
      updateEntries();
    });
  }

  // ------ FILTERS ------

  // Method called when the bottom navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedViewType = ViewTypes.values[index];
      updateEntries();
    });
  }

  // Method that updates the entry list depending on all the filters.
  void updateEntries() {
    updateEntriesByViewType();
    updateEntriesByFilter();
  }

  // Method that updates the entry list given a view type.
  void updateEntriesByViewType() {
    // Clear the list.
    entryListByView.clear();
    // Get the entries given the view type.
    switch (_selectedViewType) {
      case ViewTypes.all:
        entryListByView = List.from(infoManager.entryList);
        break;
      case ViewTypes.income:
        // For every entry, check if its value is positive and add it to the list.
        for (Entry entry in List.from(infoManager.entryList)) {
          if (entry.value >= 0.0) {
            entryListByView.add(entry);
          }
        }
        break;
      case ViewTypes.expense:
        // For every entry, check if its value is negative and add it to the list.
        for (Entry entry in List.from(infoManager.entryList)) {
          if (entry.value < 0.0) {
            entryListByView.add(entry);
          }
        }
        break;
    }
  }

  // Method that updates the entry list given a filter.
  void updateEntriesByFilter() {
    List<Entry> tmpEntryList = [];
    for (Entry entry in entryListByView) {
      if (Utils.filterEntryByDate(entry.date, filterSelected)) {
        tmpEntryList.add(entry);
      }
    }
    entryListByView = List.from(tmpEntryList);
  }

  // Custom Dropdown for the filters.
  Widget dropDownFilters() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(34, 146, 146, 146),
        border: Border.all(
          color: const Color.fromARGB(45, 146, 146, 146),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        value: filterSelected,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        icon: const Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
        iconSize: 20,
        elevation: 16,
        dropdownColor: const Color.fromARGB(255, 45, 48, 51),
        underline: Container(
          height: 0,
        ),
        focusColor: const Color.fromARGB(255, 45, 48, 51),
        items: filterList.map((String filter) {
          return DropdownMenuItem(
            value: filter,
            child: Text(
              filter,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            filterSelected = newValue!;
            updateEntries();
          });
        },
      ),
    );
  }
}
