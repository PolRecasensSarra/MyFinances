import 'package:flutter/material.dart';

import 'Utils.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  // Selected filter.
  Filters filterSelected = Filters.month;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Apply filter",
          ),
          bottom: const TabBar(
            unselectedLabelColor: Color.fromARGB(255, 182, 182, 182),
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(
                child: Text(
                  "Classic",
                ),
              ),
              Tab(
                child: Text(
                  "Advanced",
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, bottom: 40.0, top: 20.0),
              child: Column(children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      classicMode(),
                      advancedMode(),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, filterSelected);
                      },
                      child: const Text(
                        "Apply",
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // Method that returns the classic mode view.
  Widget classicMode() {
    return const Text("Classic Mode");
  }

  // Method that returns the advanced mode view.
  Widget advancedMode() {
    return const Text("Advanced Mode");
  }
}
