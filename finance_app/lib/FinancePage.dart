import 'package:finance_app/Entry.dart';
import 'package:finance_app/FiltersPage.dart';
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
  List<Entry> entryListFiltered = [];
  // Selected filter.
  Filters filterSelected = Filters.month;

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
          popUpMenuButton(),
        ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 29, 31, 33),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 194, 194, 194),
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
              Icons.euro_symbol_outlined,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 79, 135, 231),
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 15.0, top: 15.0),
            child: Column(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    "Your balance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                // Balance box.
                Expanded(
                  flex: 22,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Color.fromARGB(255, 164, 93, 230)
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
                // History box.
                Expanded(
                  flex: 62,
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
                    child: entryListFiltered.isEmpty
                        ? emptyBalanceListPlaceholder()
                        : Scrollbar(
                            thumbVisibility: true,
                            controller: scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: entryListFiltered.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Utils.getColorByEntryValue(
                                      entryListFiltered[index].value),
                                  child: ListTile(
                                    title: Text(
                                      entryListFiltered[index].concept,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      Utils.getFormattedDateTime(
                                          entryListFiltered[index].date),
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    trailing: Text(
                                      "${entryListFiltered[index].value.toPrecision(Utils.decimalPrecission)} €",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    focusColor: Utils.getColorByEntryValue(
                                        entryListFiltered[index].value),
                                    hoverColor: Utils.getColorByEntryValue(
                                        entryListFiltered[index].value),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    onLongPress: () {
                                      showAlertDialog(context, true,
                                          entry: entryListFiltered[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Filter: ${Utils.filtersMap[filterSelected]!}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
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
    for (var entry in entryListFiltered) {
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
    entryListFiltered = Utils.customSortByDate(entryListFiltered);
  }

  // Method that updates the entry list given a view type.
  void updateEntriesByViewType() {
    // Clear the list.
    entryListFiltered.clear();
    // Get the entries given the view type.
    switch (_selectedViewType) {
      case ViewTypes.all:
        entryListFiltered = List.from(infoManager.entryList);
        break;
      case ViewTypes.income:
        // For every entry, check if its value is positive and add it to the list.
        for (Entry entry in List.from(infoManager.entryList)) {
          if (entry.value >= 0.0) {
            entryListFiltered.add(entry);
          }
        }
        break;
      case ViewTypes.expense:
        // For every entry, check if its value is negative and add it to the list.
        for (Entry entry in List.from(infoManager.entryList)) {
          if (entry.value < 0.0) {
            entryListFiltered.add(entry);
          }
        }
        break;
    }
  }

  // Method that updates the entry list given a filter.
  void updateEntriesByFilter() {
    List<Entry> tmpEntryList = [];
    for (Entry entry in entryListFiltered) {
      if (Utils.filterEntryByDate(entry.date, filterSelected)) {
        tmpEntryList.add(entry);
      }
    }
    entryListFiltered = List.from(tmpEntryList);
  }

  // Method that returns a placeholder text when there are no entries.
  Widget emptyBalanceListPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Wow, it's really calm in here!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Add a new entry to the balance.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget popUpMenuButton() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Filters",
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Delete History",
            ),
          ),
        ];
      },
      onSelected: (value) {
        // Filter option selected.
        if (value == 0) {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (contextCallback) =>
                  FiltersPage(currentFilter: filterSelected),
            ),
          )
              .then((value) {
            setState(() {
              // Check that the value recieved is valid and is type Filters.
              if (value != null && value is Filters) {
                filterSelected = value;
              }
              // Update the entries when the entry page pops.
              updateEntries();
            });
          });
        }
        // Delete history record option selected.
        else if (value == 1) {
          showAlertDialog(context, false);
        }
      },
    );
  }
}
