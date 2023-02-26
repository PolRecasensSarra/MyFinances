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
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 25.0, top: 25.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: LocaleText(
                "tr_help_text",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
