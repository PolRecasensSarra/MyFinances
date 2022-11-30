import 'package:flutter/material.dart';

import 'Utils.dart';

class FiltersPage extends StatefulWidget {
  final Filters currentFilter;
  const FiltersPage({super.key, required this.currentFilter});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  // Selected filter.
  Filters filterSelected = Filters.month;
  List<CheckBoxFilterTile> checkboxList = [];

  @override
  void initState() {
    super.initState();
    generateCheckBoxList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Filters",
          ),
          bottom: const TabBar(
            unselectedLabelColor: Color.fromARGB(255, 182, 182, 182),
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(
                child: Text(
                  "Classic",
                ),
              ),
              Tab(
                child: Text(
                  "Advanced",
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, bottom: 40.0, top: 20.0),
              child: Column(
                children: [
                  const Expanded(
                    flex: 5,
                    child: Text(
                      "Select a filter",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 81,
                    child: TabBarView(
                      children: [
                        classicMode(),
                        advancedMode(),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 79, 135, 231),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, filterSelected);
                          },
                          child: const Text(
                            "Apply",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method that returns the classic mode view.
  Widget classicMode() {
    return Container(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(34, 146, 146, 146),
        border: Border.all(
          color: const Color.fromARGB(45, 146, 146, 146),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListView.builder(
        itemCount: checkboxList.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 78, 78, 78),
            child: CheckboxListTile(
              value: checkboxList[index].checked,
              title: Text(
                Utils.filtersMap[checkboxList[index].filter]!,
              ),
              activeColor: const Color.fromARGB(255, 79, 135, 231),
              onChanged: (bool? value) {
                itemChanged(value!, index);
              },
            ),
          );
        },
      ),
    );
  }

  // Function called when a checkbox is clicked.
  // @param value Bool if the checkbox has been selected or deselected.
  // @param index the selected checkbox index in the list.
  void itemChanged(bool value, int index) {
    setState(() {
      if (value && !checkboxList[index].checked) {
        checkboxList[index].checked = value;

        // Save the new selected filter.
        filterSelected = checkboxList[index].filter;

        // Set all the checkbox that are not the selected one to false.
        for (var element in checkboxList) {
          if (element.filter != filterSelected) {
            element.checked = false;
          }
        }
      }
    });
  }

  // Method that returns the advanced mode view.
  Widget advancedMode() {
    return const Text("Advanced Mode");
  }

  // Method that generates the checkbox list with all the filters.
  generateCheckBoxList() {
    filterSelected = widget.currentFilter;
    checkboxList.clear();
    for (var key in Utils.filtersMap.keys) {
      checkboxList
          .add(CheckBoxFilterTile(filter: key, checked: key == filterSelected));
    }
  }
}

// Class for the checbox tile filter.
class CheckBoxFilterTile {
  Filters filter = Filters.month;
  bool checked = false;
  // Class constructor.
  CheckBoxFilterTile({required this.filter, required this.checked});
}
