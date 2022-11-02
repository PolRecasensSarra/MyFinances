import 'package:finance_app/InfoManager.dart';
import 'package:flutter/material.dart';

import 'Entry.dart';
import 'Utils.dart';

class HistoryRecordPage extends StatefulWidget {
  final InfoManager infoManager;
  HistoryRecordPage({
    required this.infoManager,
  });
  @override
  _HistoryRecordPageState createState() => _HistoryRecordPageState();
}

class _HistoryRecordPageState extends State<HistoryRecordPage> {
  ScrollController scrollController = ScrollController();
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        elevation: 0.0,
        title: const Text(
          "Record History",
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 58, 51, 73),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
          child: Center(
            child: Column(
              children: [
                const Expanded(
                  flex: 10,
                  child: Text(
                    "Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  flex: 90,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(34, 146, 146, 146),
                      border: Border.all(
                        color: const Color.fromARGB(45, 146, 146, 146),
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: widget.infoManager.entryList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: utils.getColorByEntryValue(
                                widget.infoManager.entryList[index].value),
                            child: ListTile(
                              title: Text(
                                widget.infoManager.entryList[index].concept,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                utils.getFormattedDateTime(
                                    widget.infoManager.entryList[index].date),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 180, 180, 180),
                                  fontSize: 10.0,
                                ),
                              ),
                              trailing: Text(
                                "${widget.infoManager.entryList[index].value.toPrecision(utils.decimalPrecission)} €",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              focusColor: utils.getColorByEntryValue(
                                  widget.infoManager.entryList[index].value),
                              hoverColor: utils.getColorByEntryValue(
                                  widget.infoManager.entryList[index].value),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
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
