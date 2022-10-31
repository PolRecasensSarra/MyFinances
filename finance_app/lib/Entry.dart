// Class that contains the entry info.
class Entry {
  String concept;
  double value;
  Entry(this.concept, this.value);

  // Class constructor.
  Map<String, dynamic> toJson() {
    return {"concept": concept, "value": value};
  }

  // Named constructor.
  Entry.fromJson(Map<String, dynamic> json)
      : concept = json["concept"],
        value = json["value"];
}
