import 'package:finance_app/Utilities/CustomDrawer.dart';
import 'package:finance_app/Pages/NewEntryPage.dart';
import 'package:finance_app/Utilities/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../Utilities/CustomWidgets.dart';
import '../Utilities/Utils.dart';

// Enum with the different popup menu options.
enum PopUpMenuOptions { filters, categories, languages, deleteAll }

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  ScrollController scrollController = ScrollController();
  // Enum variable that indicates the view type.
  ViewTypes _selectedViewType = ViewTypes.all;
  // Flag that indicates if the info is still being processed.
  bool loading = false;

  @override
  void initState() {
    initializeLocale();
    parseBalanceFromJson();
    parseSettingsFromJson();
    super.initState();
  }

  // Method to initialize the locales.
  void initializeLocale() async {
    await initializeDateFormatting();
  }

  // Async method to parse all the info.
  void parseBalanceFromJson() async {
    loading = true;
    await InfoManager.get.parseBalanceFromJson();
    // Force update view type.
    InfoManager.get.updateEntries(_selectedViewType);
    setState(() {
      loading = false;
    });
  }

  // Async method to parse all settings the info.
  void parseSettingsFromJson() async {
    await InfoManager.get.parseSettingsFromJson();
    setState(() {
      updateSettings();
    });
  }

  // Update the Settings after parsing them, because there's info that has to be updates in runtime.
  void updateSettings() {
    setState(() {
      LocaleNotifier.of(context)?.change(InfoManager.get.getCurrentLanguage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? showLoading()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              drawer: customDrawer(context),
              appBar: AppBar(
                title: const LocaleText("tr_my_finances"),
                backgroundColor: const Color.fromARGB(255, 39, 41, 43),
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
                items: [
                  BottomNavigationBarItem(
                    label: Locales.string(context, "tr_show_all"),
                    icon: const Icon(
                      Icons.savings,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: Locales.string(context, "tr_show_incomes"),
                    icon: const Icon(
                      Icons.euro_symbol_outlined,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: Locales.string(context, "tr_show_expenses"),
                    icon: const Icon(
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
                      builder: (contextCallback) => const NewEntryPage(),
                    ),
                  )
                      .then((_) {
                    setState(() {
                      // Update the entries when the entry page pops.
                      InfoManager.get.updateEntries(_selectedViewType);
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
                          child: LocaleText(
                            "tr_my_balance",
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
                            child: InfoManager.get.entryListFiltered.isEmpty
                                ? emptyBalanceListPlaceholder()
                                : Scrollbar(
                                    thumbVisibility: true,
                                    controller: scrollController,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      itemCount: InfoManager
                                          .get.entryListFiltered.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Utils.getColorByEntryValue(
                                              InfoManager
                                                  .get
                                                  .entryListFiltered[index]
                                                  .value),
                                          child: ListTile(
                                            title: Text(
                                              InfoManager
                                                  .get
                                                  .entryListFiltered[index]
                                                  .concept,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              Utils.getFormattedDateTime(
                                                      InfoManager
                                                          .get
                                                          .entryListFiltered[
                                                              index]
                                                          .date,
                                                      context)
                                                  .capitalize(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 196, 196, 196),
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            trailing: Text(
                                              "${InfoManager.get.entryListFiltered[index].value.toPrecision(Utils.decimalPrecission)} ${InfoManager.get.getCurrencySymbol()}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            focusColor:
                                                Utils.getColorByEntryValue(
                                                    InfoManager
                                                        .get
                                                        .entryListFiltered[
                                                            index]
                                                        .value),
                                            hoverColor:
                                                Utils.getColorByEntryValue(
                                                    InfoManager
                                                        .get
                                                        .entryListFiltered[
                                                            index]
                                                        .value),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            onLongPress: () {
                                              showDeleteHistoryDialog(
                                                  context, true,
                                                  entry: InfoManager.get
                                                          .entryListFiltered[
                                                      index]);
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const LocaleText(
                                "tr_filter",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                ": ",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              LocaleText(
                                Utils.filtersMap[
                                    InfoManager.get.filterSelected]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
            ),
          );
  }

  // Method that returns the current balance given the incomes and expenses and filters.
  double getBalance() {
    double balance = 0.0;
    // Iterate the expenses and incomes and add it to the balance.
    for (var entry in InfoManager.get.entryListFiltered) {
      balance += entry.value;
    }
    return balance;
  }

  // Method that returns the formatted balance with the current coin symbol.
  String getFormattedBalance() {
    double balance = getBalance();
    String formattedBalance =
        "${balance.toPrecision(Utils.decimalPrecission)} ${InfoManager.get.getCurrencySymbol()}";
    return formattedBalance;
  }

  // ------ FILTERS ------

  // Method called when the bottom navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedViewType = ViewTypes.values[index];
      InfoManager.get.updateEntries(_selectedViewType);
    });
  }

  // Method that returns a placeholder text when there are no entries.
  Widget emptyBalanceListPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          LocaleText(
            "tr_empty_balance_placeholder",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          LocaleText(
            "tr_add_new_entry_placeholder",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
