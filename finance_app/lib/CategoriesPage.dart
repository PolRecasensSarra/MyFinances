import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
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
  List<Color> categoryColors = [
    Colors.orange, // Others
    const Color.fromARGB(255, 229, 89, 187), // Services
    const Color.fromARGB(255, 35, 91, 186), // Housing
    Colors.yellow, // Transportation
    const Color.fromARGB(255, 131, 69, 142), // Entertainment
    const Color.fromARGB(255, 83, 201, 255), // Bizum
    const Color.fromARGB(255, 221, 176, 160), // Clothes
    const Color.fromARGB(255, 230, 65, 53), // Supers
    const Color.fromARGB(255, 22, 148, 135), // Transfers
    const Color.fromARGB(255, 192, 92, 56), // Mobile
    Colors.green, // Health
    const Color.fromARGB(255, 8, 111, 20) // Wellness
  ];
  // Map with every category associated to its expense.
  Map<String, double> categoryData = {};

  @override
  void initState() {
    setTotalExpenses();
    initializeCategoryData();
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
                  flex: 25,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 49,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Spend analytics",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${totalExpenses.toPrecision(Utils.decimalPrecission)} €",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
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
                        flex: 49,
                        child: categoriesPieChart(),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 5,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 63,
                  child: categoriesBasicView(),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
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

  // Method that returns the basic view.
  Scrollbar categoriesBasicView() {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
          padding: const EdgeInsets.only(
            right: 15.0,
          ),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: categoryData.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${categoryData.keys.elementAt(index).capitalize()} - ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${(getExpensePercentage(categoryData.values.elementAt(index)) * 100).toPrecision(Utils.decimalPrecission)} %",
                        ),
                      ],
                    ),
                    Text(
                      "${categoryData.values.elementAt(index).toPrecision(Utils.decimalPrecission)} €",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                getPercentageBar(index),
                const SizedBox(
                  height: 25.0,
                ),
              ],
            );
          }),
    );
  }

  // Method that returns a PieChart of the different category expenses.
  Widget categoriesPieChart() {
    return PieChart(
      dataMap: categoryData,
      animationDuration: const Duration(milliseconds: 800),
      chartType: ChartType.ring,
      chartLegendSpacing: 16,
      colorList: categoryColors,
      legendOptions: const LegendOptions(
        showLegends: false,
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: false,
      ),
    );
  }

  // Method that returns a percentage bar widget of a category.
  // @param categoryIndex int the index of the category in the data map.
  Widget getPercentageBar(int categoryIndex) {
    double percentage =
        getExpensePercentage(categoryData.values.elementAt(categoryIndex));
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 8,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 122, 122, 122),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * percentage,
        height: 8,
        decoration: BoxDecoration(
          color: categoryColors[categoryIndex],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ]);
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
  // @param expense double the value from which to calculate the percentage.
  // @result double the percentage of the expenses(from 0 to 1).
  double getExpensePercentage(double expense) {
    return totalExpenses > 0.0 ? expense / totalExpenses : 0.0;
  }

  // Method that calculates the total expense given the entries.
  void setTotalExpenses() {
    for (Entry entry in widget.entryListFiltered) {
      if (entry.value < 0.0) {
        totalExpenses += entry.value.abs();
      }
    }
  }

  // Method that given all the categories, creates a map of every category and its expense.
  void initializeCategoryData() {
    for (var category in Categories.values) {
      // If the map data doesn't have the category, add it.
      if (!categoryData.containsKey(category.name)) {
        categoryData[category.name.capitalize()] =
            getExpenseByCategory(category).toPrecision(Utils.decimalPrecission);
      }
    }

    // Sort the category map by value from higher to lower.
    categoryData = Map.fromEntries(categoryData.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
  }
}
