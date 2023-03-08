import 'package:currency_picker/currency_picker.dart';
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
                left: 40.0, right: 40.0, bottom: 25.0, top: 25.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: LocaleText(
                    "tr_select_currency",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: false,
                      showSearchField: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      theme: CurrencyPickerThemeData(
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height * 0.65,
                      ),
                      onSelect: (Currency currency) {
                        print('Select currency: ${currency.symbol}');
                      },
                      favorite: ['EUR'],
                    );
                  },
                  child: const LocaleText("tr_select_currency"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
