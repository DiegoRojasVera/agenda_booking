class Stylist {
  Stylist({
    required this.id,
    required this.name,
    required this.photo,
    required this.score,
    required this.lockedDates,
  });

  int id;
  String name;
  String photo;
  double score;
  List<DateTime> lockedDates;

  factory Stylist.fromJson(Map<String, dynamic> json) => Stylist(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    score: json["score"].toDouble(),
    lockedDates: List<DateTime>.from(
        json["locked_dates"].map((x) => DateTime.parse(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "score": score,
    "locked_dates":
    List<dynamic>.from(lockedDates.map((x) => x.toIso8601String())),
  };
}
