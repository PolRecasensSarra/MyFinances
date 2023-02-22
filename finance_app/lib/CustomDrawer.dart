import 'package:finance_app/FinancePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'CategoriesPage.dart';
import 'FiltersPage.dart';
import 'LanguagesPage.dart';

// Custom Drawer widget.
Widget customDrawer(BuildContext context) {
  return Drawer(
    child: ListView(children: [
      DrawerHeader(
        decoration: const BoxDecoration(color: Colors.teal),
        child: Container(),
      ),
      ListTile(
        leading: const Icon(Icons.home_filled),
        title: const LocaleText("tr_home"),
        onTap: () {
          // Check that the selected page is not the current page.
          if (const FinancePage().toString() != context.widget.toString()) {
            // Navigate to the filters page.
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
      const Divider(
        height: 2.0,
      ),
      ListTile(
        leading: const Icon(Icons.filter_alt),
        title: const LocaleText("tr_filters"),
        onTap: () {
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
      const Divider(
        height: 2.0,
      ),
      ListTile(
        leading: const Icon(Icons.category),
        title: const LocaleText("tr_categories"),
        onTap: () {
          // Check that the selected page is not the current page.
          if (const CategoriesPage().toString() != context.widget.toString()) {
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
      const Divider(
        height: 2.0,
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: const LocaleText("tr_languages"),
        onTap: () {
          // Check that the selected page is not the current page.
          if (const LanguagesPage().toString() != context.widget.toString()) {
            // Navigate to the languages page.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (contextCallback) => const LanguagesPage(),
              ),
            );
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      const Divider(
        height: 2.0,
      ),
      ListTile(
        leading: const Icon(Icons.delete),
        title: const LocaleText("tr_delete_history"),
        onTap: () {
          // Show ther alert dialogue.
          // TODO: fer que el alert dialogue sigui una classe apart i es pugui instanciar des de qualsevol pàgina.
          //showAlertDialog(context, false);
        },
      ),
      const Divider(
        height: 2.0,
      ),
      ListTile(
        leading: const Icon(Icons.info),
        title: const LocaleText("tr_about"),
        onTap: () {
          // Close the drawer.
          Navigator.pop(context);
          // TODO: obrir un panel amb la info.
        },
      ),
      const Divider(
        height: 2.0,
      ),
    ]),
  );
}
