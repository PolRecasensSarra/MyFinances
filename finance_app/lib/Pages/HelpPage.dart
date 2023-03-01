import 'package:flutter/material.dart';
import 'package:finance_app/Utilities/CustomDrawer.dart';
import 'package:flutter_locales/flutter_locales.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: customDrawer(context),
        appBar: AppBar(
          title: const LocaleText(
            "tr_help",
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 25.0, top: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    LocaleText(
                      "tr_help_title00",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    LocaleText(
                      "tr_help_text00",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    LocaleText(
                      "tr_help_title01",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    LocaleText(
                      "tr_help_text01",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    LocaleText(
                      "tr_help_title02",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    LocaleText(
                      "tr_help_text02",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
