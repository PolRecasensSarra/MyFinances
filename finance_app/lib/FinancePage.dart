import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  TextEditingController nameTextCtrl = TextEditingController();
  TextEditingController valueTextCtrl = TextEditingController();
  List<Map<double, String>> expensesList = [];
  List<Map<double, String>> incomesList = [];
  String error = "";
  String concept = "";
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 51, 73),
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
        child: Center(
          child: Column(children: [
            const Expanded(
              flex: 15,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Finance App",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Color.fromARGB(255, 135, 30, 233)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Center(
                    child: Text(
                      getFormattedBalance(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 30,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "History",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 130.0,
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 35,
              child: Container(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "New entry",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: nameTextCtrl,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 94, 94, 94),
                        contentPadding:
                            const EdgeInsets.all(8.0), //here your padding
                        hintText: "Add expense or income concept",
                        suffixIcon:
                            const Icon(Icons.text_snippet, color: Colors.white),
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 146, 146, 146),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 146, 146, 146)),
                        ),
                      ),
                      validator: (val) =>
                          concept.isEmpty ? "Enter a new entry" : null,
                      onChanged: (val) {
                        setState(() {
                          concept = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: valueTextCtrl,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ], // Only numbers can be entered
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 94, 94, 94),
                        contentPadding:
                            const EdgeInsets.all(8.0), //here your padding
                        hintText: "Add expense or income value",
                        suffixIcon: const Icon(Icons.attach_money_outlined,
                            color: Colors.white),
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 146, 146, 146),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 146, 146, 146)),
                        ),
                      ),
                      validator: (val) =>
                          value == 0.0 ? "Enter a new entry" : null,
                      onChanged: (val) {
                        setState(() {
                          final tmpValue =
                              val.isEmpty ? 0.0 : double.tryParse(val);
                          if (tmpValue != null) {
                            value = tmpValue;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.blueAccent,
                                ),
                              ),
                              child: const Text(
                                "Add income",
                              ),
                              onPressed: () {
                                updateBalance(incomesList);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 124, 69, 175),
                                ),
                              ),
                              child: const Text(
                                "Add expense",
                              ),
                              onPressed: () {
                                updateBalance(expensesList);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

// Method that updates the current balance.
  void updateBalance(List<Map<double, String>> listDestination) {
    error = "";
    // Check that the concept and value are filled.
    if (nameTextCtrl.text.isNotEmpty &&
        (valueTextCtrl.text.isEmpty
                ? 0.0
                : double.tryParse(valueTextCtrl.text))! >
            0.0) {
      // Add a new income to the list.
      listDestination.add(<double, String>{value: concept});

      // Clear the input field texts.
      nameTextCtrl.clear();
      valueTextCtrl.clear();
      concept = "";
      value = 0.0;
    } else {
      error = "Concept and value cannot be null.";
    }
    // Force update the state.
    setState(() {});
  }

  // Method that returns the current balance given the incomes and expenses.
  double getBalance() {
    double balance = 0.0;
    // Iterate the incomes and add it to the balance.
    for (var map in incomesList) {
      for (var key in map.keys) {
        balance += key;
      }
    }
    // Iterate all the expenses and subtract it from the balance.
    for (var map in expensesList) {
      for (var key in map.keys) {
        balance -= key;
      }
    }
    return balance;
  }

  // Method that returns the formatted balance with the current coin symbol.
  String getFormattedBalance() {
    double balance = getBalance();
    String formattedBalance = "$balance €";
    return formattedBalance;
  }
}
