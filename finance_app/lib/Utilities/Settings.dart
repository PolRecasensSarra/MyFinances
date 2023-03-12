// Class that contains the Settings info.

class Settings {
  // Selected currency symbol. F.e. €, $
  String currencySymbol = "";
  // Selected currency name: EUR, USD...
  String currencyName = "";
  // Selected language code. ca, en, es...
  String languageCode = "";

  // Class constructor.
  Settings();

  // Convert this class to json format.
  Map<String, dynamic> toJson() {
    return {
      "currency_symbol": currencySymbol,
      "currency_name": currencyName,
      "language_code": languageCode
    };
  }

  // Named constructor.
  Settings.fromJson(Map<String, dynamic> json)
      : currencySymbol =
            json.containsKey("currency_symbol") ? json["currency_symbol"] : "",
        currencyName =
            json.containsKey("currency_name") ? json["currency_name"] : "",
        languageCode =
            json.containsKey("language_code") ? json["language_code"] : "";

  // Reset all the custom settings.
  void resetSettings() {
    currencySymbol = "";
    currencyName = "";
    languageCode = "";
  }
}
