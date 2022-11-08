import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'Entry.dart';

class InfoManager {
  // List with all the incomes and expenses.
  List<Entry> entryList = [];

  // Method that reads from the savedata file.
  Future<void> parseBalanceFromJson() async {
    // Clear the entry list to make sure no residual data stays.
    entryList.clear();
    // Get the save data file.
    File dataFile = await getSaveDataFile();
    List<dynamic> jsonData;
    // If the file exists, read it as a String.
    if (await dataFile.exists()) {
      String content = await dataFile.readAsString();
      jsonData = jsonDecode(content);
      // Iterate the jsonData and fill the entry list with the info.
      for (var entry in jsonData) {
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

  // Method to add a new entry to the list.
  void addNewEntry(Entry entry) {
    entryList.insert(0, entry);
  }

  // Method that returns the curent File object fo the save data file.
  Future<File> getSaveDataFile() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return File("${directory!.path}/savedata.save");
  }
}
