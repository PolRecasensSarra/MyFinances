import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'Entry.dart';
import '../Pages/FinancePage.dart';
import 'InfoManager.dart';

/// Method that shows an alert dialog in order to delete the record history.
///
/// The `partialDelete` parameter (bool) is used to know if the deletion is total or only an entry.
///
/// The `entry` parameter (Entry) is an optional parameter. If `partialDelete` is true, `entry` is mandatory.
showDeleteHistoryDialog(BuildContext context, bool partialDelete,
    {Entry? entry}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog(context, partialDelete, entry: entry);
    },
  );
}

// Method that returns an alert dialog depending on if we want to delete an entry or the entire history.
Widget alertDialog(BuildContext context, bool partialDelete, {Entry? entry}) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Colors.blueAccent,
      ),
    ),
    child: const LocaleText("tr_cancel"),
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
    child: const LocaleText("tr_continue"),
    onPressed: () {
      if (partialDelete) {
        // Remove the entry.
        InfoManager.get.deleteEntry(entry);
      } else {
        // Clear the entire list.
        InfoManager.get.deleteAllHistory();
      }
      // Navigate to the home page.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (contextCallback) => const FinancePage(),
        ),
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      Locales.string(context,
          partialDelete ? "tr_delete_entry_popup" : "tr_delete_history_popup"),
    ),
    content: Text(
      Locales.string(
          context,
          partialDelete
              ? "tr_delete_entry_popup_text"
              : "tr_delete_history_popup_text"),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  return alert;
}
