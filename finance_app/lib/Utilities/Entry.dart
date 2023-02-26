// Class that contains the entry info.

class Entry {
  String concept;
  double value;
  String date;
  int category;

  // Class constructor.
  Entry(this.concept, this.value, this.date, this.category);

  // Convert this class to json format.
  Map<String, dynamic> toJson() {
    return {"concept": concept, "value": value, "date": date, "category": category};
  }

  // Named constructor.
  Entry.fromJson(Map<String, dynamic> json)
      : concept =
            json.containsKey("concept") ? json["concept"] : "No concept found",
        value = json.containsKey("value") ? json["value"] : 0.0,
        date = json.containsKey("date")
            ? json["date"]
            : DateTime.utc(1970).toString(),
            category = json.containsKey("category") ? json["category"] : 0;
}
