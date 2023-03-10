import 'package:currency_picker/currency_picker.dart';
import 'package:finance_app/Utilities/InfoManager.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/Utilities/CustomDrawer.dart';
import 'package:flutter_locales/flutter_locales.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
}
