// Class that contains the entry info.
class Entry {
  String concept;
  double value;
  String date;

  // Class constructor.
  Entry(this.concept, this.value, this.date);

  // Convert this class to json format.
  Map<String, dynamic> toJson() {
    return {"concept": concept, "value": value, "date": date};
  }

  // Named constructor.
  Entry.fromJson(Map<String, dynamic> json)
      : concept =
            json.containsKey("concept") ? json["concept"] : "No concept found",
        value = json.containsKey("value") ? json["value"] : 0.0,
        date = json.containsKey("date")
            ? json["date"]
            : DateTime.utc(1970).toString();
}
