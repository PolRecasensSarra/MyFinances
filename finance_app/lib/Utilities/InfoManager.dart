import 'dart:convert';
import 'dart:io';
import 'package:finance_app/Utilities/Settings.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
  // Custom user Settings class.
  Settings customSettings = Settings();

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
  Future<void> saveBalanceToJson() async {
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
    File dataFile = await getSettingsDataFile();
    Map<String, dynamic> jsonDataEntries;
    Map<String, dynamic> settings;
    // If the file exists, read it as a String.
    if (await dataFile.exists()) {
      String content = await dataFile.readAsString();
      jsonDataEntries = jsonDecode(content);
      // Decode the settings. {"settings":{}}
      settings = jsonDecode(jsonDataEntries["settings"]);
      customSettings = Settings.fromJson(settings);
    }
  }

  // Method that writes the settings to the save data file.
  void saveSettingsToJson() async {
    // Get the data file.
    File dataFile = await getSettingsDataFile();
    // Encode the settings as a json string.
    String encodedData = jsonEncode(customSettings);
    encodedData = jsonEncode({"settings": encodedData});
    // Save the data. If the file does not exist, it will be created.
    await dataFile.writeAsString(encodedData);
  }

  // Method that deletes all the entry history from the save data file.
  Future<void> deleteAllHistory() async {
    // Clear the entire list.
    entryList.clear();
    // Force save the data.
    await saveBalanceToJson();
  }

  // Method to delete an entry.
  Future<void> deleteEntry(Entry? entry) async {
    // Remove the entry.
    entryList.remove(entry);
    // Force save the list again.
    await saveBalanceToJson();
  }

  // Reset the settings.
  void resetSettingsConfiguration() async {
    customSettings.resetSettings();
    //saveSettingsToJson();
    // Get the data file.
    File dataFile = await getSettingsDataFile();
    // Encode the settings as a json string.
    String encodedData = jsonEncode({"settings": jsonEncode({})});
    // Save the data. If the file does not exist, it will be created.
    await dataFile.writeAsString(encodedData);
  }

  // Method to add a new entry to the list.
  void addNewEntry(Entry entry) {
    entryList.add(entry);
    saveBalanceToJson();
  }

  // Method that returns the curent File object fo the save data file.
  Future<File> getSaveDataFile() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return File("${directory!.path}/savedata.save");
  }

  // Method that returns the curent File object fo the settings data file.
  Future<File> getSettingsDataFile() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return File("${directory!.path}/settingsdata.save");
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

  // Returns the settings currency symbol. If it is empty, returns the currency symbol according to the current locale.
  String getCurrencySymbol() {
    return customSettings.currencySymbol.isNotEmpty
        ? customSettings.currencySymbol
        : NumberFormat.simpleCurrency(
                locale: Locales.selectedLocale.languageCode)
            .currencySymbol;
  }

  // Returns the settings currency name. If it is empty, returns the currency name according to the current locale.
  String? getCurrencyName() {
    return customSettings.currencySymbol.isNotEmpty
        ? customSettings.currencyName
        : NumberFormat.simpleCurrency(
                locale: Locales.selectedLocale.languageCode)
            .currencyName;
  }

  // Returns the language stored in the settings data or the selected one if it is empty.
  String getCurrentLanguage() {
    return customSettings.languageCode.isNotEmpty
        ? customSettings.languageCode
        : Locales.selectedLocale.languageCode;
  }
}
