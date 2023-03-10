import 'package:finance_app/Pages/FinancePage.dart';
import 'package:finance_app/Pages/HelpPage.dart';
import 'package:finance_app/Pages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../Pages/CategoriesPage.dart';
import 'CustomWidgets.dart';
import '../Pages/FiltersPage.dart';

/// Custom Drawer widget.
Widget customDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        const SizedBox(
          height: kToolbarHeight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: getTileColor(context, const FinancePage().toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.home_filled,
            ),
            title: const LocaleText("tr_home"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (const FinancePage().toString() != context.widget.toString()) {
                // Navigate to the home page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (contextCallback) => const FinancePage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: getTileColor(context, const FiltersPage().toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.filter_alt,
            ),
            title: const LocaleText("tr_filters"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (const FiltersPage().toString() != context.widget.toString()) {
                // Navigate to the filters page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (contextCallback) => const FiltersPage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: getTileColor(context, const CategoriesPage().toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.category,
            ),
            title: const LocaleText("tr_categories"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (const CategoriesPage().toString() !=
                  context.widget.toString()) {
                // Navigate to the categories page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (contextCallback) => const CategoriesPage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        const SizedBox(height: 10.0),
        const Divider(
          height: 2.0,
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: getTileColor(context, const SettingsPage().toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.settings,
            ),
            title: const LocaleText("tr_settings"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (const SettingsPage().toString() !=
                  context.widget.toString()) {
                // Navigate to the settings page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (contextCallback) => const SettingsPage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.delete,
            ),
            title: const LocaleText("tr_delete_history"),
            onTap: () {
              // Close the drawer.
              Navigator.of(context).pop();
              // Show ther alert dialogue.
              showDeleteHistoryDialog(context, false);
            },
          ),
        ),
        const SizedBox(height: 10.0),
        const Divider(
          height: 2.0,
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            tileColor: getTileColor(context, const HelpPage().toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.help,
            ),
            title: const LocaleText("tr_help"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (const HelpPage().toString() != context.widget.toString()) {
                // Navigate to the help page.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (contextCallback) => const HelpPage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.info,
            ),
            title: const LocaleText("tr_about"),
            onTap: () {
              // Close the drawer.
              Navigator.pop(context);
              showAboutDialogCustom(context);
            },
          ),
        ),
      ],
    ),
  );
}

/// Method that given the current `context` and the desired `pageName`, returns the color of the tile, highlighting it if
/// the current visualized page is the desired page.
Color getTileColor(BuildContext context, String pageName) {
  return (pageName != context.widget.toString())
      ? Colors.transparent
      : const Color.fromARGB(255, 90, 90, 90);
}
