import 'package:finance_app/Entry.dart';
import 'package:finance_app/Filter.dart';
import 'package:finance_app/InfoManager.dart';
import 'package:flutter/material.dart';
import 'Utils.dart';

// Enum with the different view types.
enum ViewTypes { all, income, expense }

class HistoryRecordPage extends StatefulWidget {
  final InfoManager infoManager;
  HistoryRecordPage({
    required this.infoManager,
  });
  @override
  _HistoryRecordPageState createState() => _HistoryRecordPageState();
}

class _HistoryRecordPageState extends State<HistoryRecordPage> {
  ScrollController scrollController = ScrollController();
  // Enum variable that indicates the view type.
  ViewTypes _selectedViewType = ViewTypes.all;
  // Local entry list modified by the view selected type.
  List<Entry> entryListByView = [];
  String filterSelected = Utils.filters.first;

  @override
  void initState() {
    updateEntriesByViewType();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RECORD HISTORY",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 58, 51, 73),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: const Color.fromARGB(255, 100, 206, 255),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(34, 146, 146, 146),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: DropdownButton<String>(
                    value: filterSelected,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    items: Utils.filters.map((String filter) {
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
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 90,
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
                                ),
                              ),
                              focusColor: Utils.getColorByEntryValue(
                                  entryListByView[index].value),
                              hoverColor: Utils.getColorByEntryValue(
                                  entryListByView[index].value),
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
        ),
      ),
    );
  }

  // Method called when the bottom navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedViewType = ViewTypes.values[index];
      updateEntriesByViewType();
    });
  }

  // Method that updates the entry list given the view type.
  void updateEntriesByViewType() {
    // Clear the list.
    entryListByView.clear();
    // Get the entries given the view type.
    switch (_selectedViewType) {
      case ViewTypes.all:
        entryListByView = List.from(widget.infoManager.entryList);
        break;
      case ViewTypes.income:
        // For every entry, check if its value is positive and add it to the list.
        for (Entry entry in List.from(widget.infoManager.entryList)) {
          if (entry.value >= 0.0) {
            entryListByView.add(entry);
          }
        }
        break;
      case ViewTypes.expense:
        // For every entry, check if its value is negative and add it to the list.
        for (Entry entry in List.from(widget.infoManager.entryList)) {
          if (entry.value < 0.0) {
            entryListByView.add(entry);
          }
        }
        break;
    }
  }
}
