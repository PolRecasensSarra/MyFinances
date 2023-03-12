import 'package:currency_picker/currency_picker.dart';
import 'package:finance_app/Utilities/CustomWidgets.dart';
import 'package:finance_app/Utilities/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/Utilities/CustomDrawer.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../Utilities/Utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          title: const LocaleText(
            "tr_settings",
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 25.0, top: 25.0),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LocaleText(
                        "tr_currency",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        "${InfoManager.get.getCurrencyName()!}  ${InfoManager.get.getCurrencySymbol()}",
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    iconSize: 28.0,
                    onPressed: () {
                      openCurrencySelector();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ),
                const Divider(
                  height: 2.0,
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LocaleText(
                        "tr_language",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      LocaleText(
                        Locales.selectedLocale.languageCode,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    iconSize: 28.0,
                    onPressed: () {
                      openLanguageSelector();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ),
                const Divider(
                  height: 2.0,
                ),
                ListTile(
                  title: const LocaleText(
                    "tr_reset_settings",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 146, 101, 101),
                      ),
                    ),
                    child: const LocaleText(
                      "tr_reset",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showResetSettingsDialog(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Open the currency picker.
  void openCurrencySelector() {
    showCurrencyPicker(
      context: context,
      showFlag: false,
      showSearchField: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      theme: CurrencyPickerThemeData(
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      onSelect: (Currency currency) {
        InfoManager.get.customSettings.currencySymbol = currency.symbol;
        InfoManager.get.customSettings.currencyName = currency.code;
        InfoManager.get.saveSettingsToJson();
        setState(() {});
      },
      favorite: ['EUR'],
    );
  }

  void openLanguageSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(31, 118, 130, 153),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
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
                      borderRadius: BorderRadius.circular(10.0), //<-- SEE HERE
                    ),
                    trailing:
                        getTrailingIcon(Languages.values[index].name, context),
                    selected: getSelectedLocale(
                        Languages.values[index].name, context),
                    selectedTileColor: const Color.fromARGB(255, 91, 100, 112),
                    onTap: () {
                      setState(() {
                        InfoManager.get.customSettings.languageCode =
                            Languages.values[index].name;
                        InfoManager.get.saveSettingsToJson();
                        LocaleNotifier.of(context)
                            ?.change(Languages.values[index].name);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
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
}
