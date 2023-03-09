// Class that contains the entry info.

class Settings {
  // Selected currency symbol. F.e. €, $
  String currencySymbol = "";

  // Class constructor.
  Settings();

  // Convert this class to json format.
  Map<String, dynamic> toJson() {
    return {"currency_symbol": currencySymbol};
  }

  // Named constructor.
  Settings.fromJson(Map<String, dynamic> json)
      : currencySymbol =
            json.containsKey("currency_symbol") ? json["currency_symbol"] : "";

  // Reset all the custom settings.
  void resetSettings() {
    currencySymbol = "";
  }
}
