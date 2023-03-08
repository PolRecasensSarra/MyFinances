import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'Entry.dart';
import 'Utils.dart';

// Class that manages all the information.
class InfoManager {
  static final InfoManager get = InfoManager();
  // ------- VARIABLES -------

  // List with all the incomes and expenses.
  List<Entry> entryList = [];
  // Local entry list modified by the view selected type.
  List<Entry> entryListFiltered = [];
  // Selected filter.
  Filters filterSelected = Filters.month;
  // Custom DateTime for the custom filter.
  DateTime customFilterDateStart = DateTime.now();
  DateTime customFilterDateEnd = DateTime.now();
  // TODO: crear la classe Settings igual que Entry.

  // ------- METHODS -------

  // Method that reads from the savedata file.
  Future<void> parseBalanceFromJson() async {
    // Clear the entry list to make sure no residual data stays.
    entryList.clear();
    // Get the save data file.
    File dataFile = await getSaveDataFile();
    Map<String, dynamic> jsonDataEntries;
    List<dynamic> entries;
    // If the file exists, read it as a String.
    if (await dataFile.exists()) {
      String content = await dataFile.readAsString();
      jsonDataEntries = jsonDecode(content);
      // Decode the entries. {"entries":[entry00, entry01...]}
      entries = jsonDecode(jsonDataEntries["entries"]);
      // Iterate the jsonData and fill the entry list with the info.
      for (var entry in entries) {
        entryList.add(Entry.fromJson(entry));
      }
    }
  }

  // Method that writes info to the save data file.
  void saveBalanceToJson() async {
    // Get the data file.
    File dataFile = await getSaveDataFile();
    // Encode the entry list as a json string.
    String encodedData = jsonEncode(entryList);
    encodedData = jsonEncode({"entries": encodedData});
    // Save the data. If the file does not exist, it will be created.
    await dataFile.writeAsString(encodedData);
  }

  // Method that reads the settings from the savedata file.
  Future<void> parseSettingsFromJson() async {
    // Get the save data file.
    File dataFile = await getSaveDataFile();
    Map<String, dynamic> jsonDataEntries;
    Map<String, dynamic> settings;
    // If the file exists, read it as a String.
    if (await dataFile.exists()) {
      String content = await dataFile.readAsString();
      jsonDataEntries = jsonDecode(content);
      // Decode the settings. {"settings":{}}
      settings = jsonDecode(jsonDataEntries["settings"]);
      // TODO: initialize the settings class.
    }
  }

  // Method that writes the settings to the save data file.
  void saveSettingsToJson() async {
    // Get the data file.
    File dataFile = await getSaveDataFile();
    // Encode the entry list as a json string.
    // TODO: encodar aquí el Mapa dels settings.
    String encodedData = jsonEncode(null);
    encodedData = jsonEncode({"settings": encodedData});
    // Save the data. If the file does not exist, it will be created.
    await dataFile.writeAsString(encodedData);
  }

  // Method that deletes all the entry history from the save data file.
  void deleteAllHistory() {
    // Clear the entire list.
    entryList.clear();
    // Force save the data.
    saveBalanceToJson();
  }

  // Method to delete an entry.
  void deleteEntry(Entry? entry) {
    // Remove the entry.
    entryList.remove(entry);
    // Force save the list again.
    saveBalanceToJson();
  }

  void resetSettingsConfiguration() {
    // TODO: resetejar els settings i saveSettingsToJson().
  }

  // Method to add a new entry to the list.
  void addNewEntry(Entry entry) {
    entryList.add(entry);
  }

  // Method that returns the curent File object fo the save data file.
  Future<File> getSaveDataFile() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return File("${directory!.path}/savedata.save");
  }

  // Method that updates the entry list depending on all the filters.
  // @param selectedViewType ViewTypes the current visualization mode.
  void updateEntries(ViewTypes selectedViewType) {
    updateEntriesByViewType(selectedViewType);
    updateEntriesByFilter();
    entryListFiltered = Utils.customSortByDate(entryListFiltered);
  }

  // Method that updates the entry list given a view type.
  // @param selectedViewType ViewTypes the current visualization mode.
  void updateEntriesByViewType(ViewTypes selectedViewType) {
    // Clear the list.
    entryListFiltered.clear();
    // Get the entries given the view type.
    switch (selectedViewType) {
      case ViewTypes.all:
        entryListFiltered = List.from(entryList);
        break;
      case ViewTypes.income:
        // For every entry, check if its value is positive and add it to the list.
        for (Entry entry in List.from(entryList)) {
          if (entry.value >= 0.0) {
            entryListFiltered.add(entry);
          }
        }
        break;
      case ViewTypes.expense:
        // For every entry, check if its value is negative and add it to the list.
        for (Entry entry in List.from(entryList)) {
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
}
