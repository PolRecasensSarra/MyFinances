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
            tileColor: getTileColor(context, FinancePage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.home_filled,
            ),
            title: const LocaleText("tr_home"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (FinancePage != context.widget.runtimeType) {
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
            tileColor: getTileColor(context, FiltersPage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.filter_alt,
            ),
            title: const LocaleText("tr_filters"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (FiltersPage != context.widget.runtimeType) {
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
            tileColor: getTileColor(context, CategoriesPage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.category,
            ),
            title: const LocaleText("tr_categories"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (CategoriesPage != context.widget.runtimeType) {
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
            tileColor: getTileColor(context, SettingsPage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.settings,
            ),
            title: const LocaleText("tr_settings"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (SettingsPage != context.widget.runtimeType) {
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
            tileColor: getTileColor(context, HelpPage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            leading: const Icon(
              Icons.help,
            ),
            title: const LocaleText("tr_help"),
            onTap: () {
              // Check that the selected page is not the current page.
              if (HelpPage != context.widget.runtimeType) {
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
Color getTileColor(BuildContext context, dynamic type) {
  return (context.widget.runtimeType != type)
      ? Colors.transparent
      : const Color.fromARGB(255, 90, 90, 90);
}
