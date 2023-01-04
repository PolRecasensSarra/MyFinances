import 'package:flutter/material.dart';
import 'Entry.dart';
import 'Utils.dart';

class CategoriesPage extends StatefulWidget {
  // Filter selected.
  final Filters currentFilter;
  // List of all entries filtered by the current filter.
  final List<Entry> entryListFiltered;
  const CategoriesPage(
      {super.key,
      required this.currentFilter,
      required this.entryListFiltered});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  ScrollController scrollController = ScrollController();
  // Total amount of expenses(money). Will be a absolute value.
  double totalExpenses = 0.0;
  // Color for each category.
  Map<Categories, Color> categoryColors = {
    Categories.others: Colors.orange,
    Categories.services: const Color.fromARGB(255, 229, 89, 187),
    Categories.housing: const Color.fromARGB(255, 35, 91, 186),
    Categories.transportation: Colors.yellow,
    Categories.entertainment: const Color.fromARGB(255, 131, 69, 142),
    Categories.bizum: const Color.fromARGB(255, 83, 201, 255),
    Categories.clothes: const Color.fromARGB(255, 221, 176, 160),
    Categories.supers: const Color.fromARGB(255, 230, 65, 53),
    Categories.transfers: const Color.fromARGB(255, 22, 148, 135),
    Categories.mobile: const Color.fromARGB(255, 192, 92, 56),
    Categories.health: Colors.green,
    Categories.wellness: const Color.fromARGB(255, 8, 111, 20)
  };

  @override
  void initState() {
    setTotalExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 25.0, top: 20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Column(
                    children: [
                      const Text(
                        "Expenses",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 199, 199, 199),
                        ),
                      ),
                      Text(
                        "${totalExpenses.toPrecision(Utils.decimalPrecission)} €",
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 70,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                        ),
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: Categories.values.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${Categories.values[index].name.capitalize()} - ",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${(getExpensePercentage(Categories.values[index]) * 100).toPrecision(Utils.decimalPrecission)} %",
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${getExpenseByCategory(Categories.values[index]).toPrecision(Utils.decimalPrecission)} €",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              getPercentageBar(Categories.values[index]),
                              const SizedBox(
                                height: 25.0,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Filter: ${Utils.filtersMap[widget.currentFilter]!}",
                      style: const TextStyle(
                        fontSize: 12,
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

  // Method that returns a percentage bar widget of a category.
  // @param category the category used.
  Widget getPercentageBar(Categories category) {
    int percA = (getExpensePercentage(category) * 100.0).toInt();
    int percB = 100 - percA;
    return Row(
      children: [
        Expanded(
          flex: percA,
          child: Container(
            height: 15,
            color: categoryColors[category],
          ),
        ),
        Expanded(
          flex: percB,
          child: Container(
            height: 15,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Method that returns the total expenses from a specific category.
  // @param category the category with which to calculate the expenses.
  // @return double the expenses for the given category.
  double getExpenseByCategory(Categories category) {
    double result = 0.0;
    for (Entry entry in widget.entryListFiltered) {
      if (entry.category == category.index && entry.value < 0.0) {
        result += entry.value.abs();
      }
    }
    return result;
  }

  // Method that calculates the percentage of expense from a given category with the total expenses.
  // @result double the percentage of the expenses(from 0 to 1).
  double getExpensePercentage(Categories category) {
    return totalExpenses > 0.0
        ? getExpenseByCategory(category) / totalExpenses
        : 0.0;
  }

  // Method that calculates the total expense given the entries.
  void setTotalExpenses() {
    for (Entry entry in widget.entryListFiltered) {
      if (entry.value < 0.0) {
        totalExpenses += entry.value.abs();
      }
    }
  }
}
