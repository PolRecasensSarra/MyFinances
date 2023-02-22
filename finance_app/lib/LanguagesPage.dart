import 'package:finance_app/CustomDrawer.dart';
import 'package:finance_app/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          title: const LocaleText(
            "tr_languages",
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 25.0, top: 25.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: LocaleText(
                    "tr_select_language",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(31, 118, 130, 153),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Languages.values.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                          title: LocaleText(
                            Languages.values[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), //<-- SEE HERE
                          ),
                          trailing: getTrailingIcon(
                              Languages.values[index].name, context),
                          selected: getSelectedLocale(
                              Languages.values[index].name, context),
                          selectedTileColor:
                              const Color.fromARGB(255, 91, 100, 112),
                          onTap: () {
                            setState(() {
                              LocaleNotifier.of(context)
                                  ?.change(Languages.values[index].name);
                            });
                          },
                        );
                      },
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
}

// Returns true if the given code is the current locale code.
// @param code String the locale code to check.
// @param context BuildContext context of this page.
bool getSelectedLocale(String code, BuildContext context) {
  return Locales.currentLocale(context)?.languageCode == code;
}

/// Method that returns a check icon if the code is the current locale code. Otherwise returns null.
// @param code String the locale code to check.
// @param context BuildContext context of this page.
Icon? getTrailingIcon(String code, BuildContext context) {
  return getSelectedLocale(code, context)
      ? const Icon(Icons.check, color: Color.fromARGB(255, 126, 255, 136))
      : null;
}
