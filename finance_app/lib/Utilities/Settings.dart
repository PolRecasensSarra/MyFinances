// Class that contains the entry info.

class Settings {
  // Selected currency symbol. F.e. €, $
  String currencySymbol = "";
  String currencyName = "";

  // Class constructor.
  Settings();

  // Convert this class to json format.
  Map<String, dynamic> toJson() {
    return {"currency_symbol": currencySymbol, "currency_name": currencyName};
  }

  // Named constructor.
  Settings.fromJson(Map<String, dynamic> json)
      : currencySymbol =
            json.containsKey("currency_symbol") ? json["currency_symbol"] : "",
        currencyName =
            json.containsKey("currency_name") ? json["currency_name"] : "";

  // Reset all the custom settings.
  void resetSettings() {
    currencySymbol = "";
    currencyName = "";
  }
}
