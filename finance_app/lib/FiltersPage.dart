import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

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
  // List f checkbox tiles.
  List<CheckBoxFilterTile> checkboxList = [];
  ScrollController scrollController = ScrollController();
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateCheckBoxList();
    dateStartController.text = Utils.getDateFormattedByLocale(
        Utils.customFilterDateStart,
        showHour: false);
    dateEndController.text = Utils.getDateFormattedByLocale(
        Utils.customFilterDateEnd,
        showHour: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocaleText(
          "filters",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 20.0, top: 20.0),
            child: Column(
              children: [
                const Expanded(
                  flex: 8,
                  child: LocaleText(
                    "select_filter_apply",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 70,
                  child: classicMode(),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 12,
                  child: filterSelected == Filters.custom
                      ? customDateSelector()
                      : Container(),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 6,
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
                        child: const LocaleText(
                          "apply",
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
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: checkboxList.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 78, 78, 78),
              child: CheckboxListTile(
                value: checkboxList[index].checked,
                title: LocaleText(
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
      ),
    );
  }

  // Function called when a checkbox is clicked.
  // @param value Bool if the checkbox has been selected or deselected.
  // @param index the selected checkbox index in the list.
  void itemChanged(bool value, int index) {
    // Get the amount of pixels for every entry in the list view.
    double pixelsPerEntry = checkboxList.isNotEmpty
        ? scrollController.position.maxScrollExtent / checkboxList.length
        : scrollController.position.minScrollExtent;
    // Jump to the entry selected knowing its size in pixels and its index inside the list view and clamp it to avoid crashes.
    scrollController.jumpTo(clampDouble(
        index * pixelsPerEntry,
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent));

    setState(() {
      if (value && !checkboxList[index].checked) {
        checkboxList[index].checked = value;
        // Save the new selected filter.
        filterSelected = checkboxList[index].filter;
        // Reset the custom dates.
        dateStartController.text = "";
        dateEndController.text = "";
        // Set all the checkbox that are not the selected one to false.
        for (var element in checkboxList) {
          if (element.filter != filterSelected) {
            element.checked = false;
          }
        }
      }
    });
  }

  // Method that generates the checkbox list with all the filters.
  void generateCheckBoxList() {
    filterSelected = widget.currentFilter;
    checkboxList.clear();
    for (var key in Utils.filtersMap.keys) {
      // Don't add the custom filter because it is not selectable.
      checkboxList
          .add(CheckBoxFilterTile(filter: key, checked: key == filterSelected));
    }
  }

  // Method that returns a custom date selector for the filter.
  Widget customDateSelector() {
    return Row(
      children: [
        // ------------- START DATE PICKER -------------
        Expanded(
          flex: 49,
          child: TextField(
            cursorColor: Colors.white,
            controller: dateStartController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 94, 94, 94),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 20.0), //here your padding
              hintText: Locales.string(context, "enter_start_date"),
              alignLabelWithHint: true,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 163, 163, 163),
                  fontStyle: FontStyle.italic),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 146, 146, 146),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 146, 146, 146)),
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: Utils.customFilterDateStart,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              // Check if the picked date is a valid date and save it.
              if (pickedDate != null) {
                setState(() {
                  Utils.customFilterDateStart = pickedDate;
                  // Set the new start date.
                  setDateControllerValue();

                  // If the start date occurs after the end, force the end date to be the start date.
                  if (Utils.customFilterDateStart
                      .isAfter(Utils.customFilterDateEnd)) {
                    Utils.customFilterDateEnd = Utils.customFilterDateStart;
                    dateEndController.text = dateStartController.text;
                  }
                });
              }
            },
          ),
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        // ------------- END DATE PICKER -------------
        Expanded(
          flex: 49,
          child: TextField(
            cursorColor: Colors.white,
            controller: dateEndController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 94, 94, 94),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 20.0), //here your padding
              hintText: Locales.string(context, "enter_end_date"),
              alignLabelWithHint: true,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 163, 163, 163),
                  fontStyle: FontStyle.italic),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 146, 146, 146),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 146, 146, 146)),
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: Utils.customFilterDateEnd,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              // Check if the picked date is a valid date and save it.
              if (pickedDate != null) {
                setState(() {
                  // Clamp the date so the end cannot be before the start.
                  Utils.customFilterDateEnd = pickedDate;
                  // Set the new end date.
                  setDateControllerValue();

                  // If the start date occurs after the end, force the end date to be the start date.
                  if (Utils.customFilterDateEnd
                      .isBefore(Utils.customFilterDateStart)) {
                    Utils.customFilterDateStart = Utils.customFilterDateEnd;
                    dateStartController.text = dateEndController.text;
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void setDateControllerValue() {
    dateStartController.text = Utils.getDateFormattedByLocale(
        Utils.customFilterDateStart,
        showHour: false);
    dateEndController.text = Utils.getDateFormattedByLocale(
        Utils.customFilterDateEnd,
        showHour: false);
  }
}

// Class for the checbox tile filter.
class CheckBoxFilterTile {
  Filters filter = Filters.month;
  bool checked = false;
  // Class constructor.
  CheckBoxFilterTile({required this.filter, required this.checked});
}
