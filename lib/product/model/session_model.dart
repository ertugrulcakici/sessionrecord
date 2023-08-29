class SessionModel {
  late String id;
  late String hour;
  late String date;
  late String name;
  late int count;
  late num income;
  late bool video;
  late double? extra;
  late double? discount;
  late String addedBy;
  late String? note;
  late String? phoneNumber;
  late String gameId;

  SessionModel({
    required this.id,
    required this.hour,
    required this.date,
    required this.name,
    required this.count,
    required this.income,
    required this.video,
    this.extra,
    this.discount,
    required this.addedBy,
    this.note,
    this.phoneNumber,
    required this.gameId,
  });
  @override
  String toString() {
    return 'SessionModel{id: $id, hour: $hour, date: $date, name: $name, count: $count, income: $income, video: $video, extra: $extra, discount: $discount, addedBy: $addedBy, note: $note, phoneNumber: $phoneNumber, gameId: $gameId}';
  }

  toJson() {
    Map<String, dynamic> _data = {
      "id": id,
      "hour": hour,
      "date": date,
      "name": name,
      "count": count,
      "income": income,
      "video": video,
      "addedBy": addedBy,
      "gameId": gameId
    };
    if (extra != null) _data["extra"] = extra;
    if (discount != null) _data["discount"] = discount;
    if (note != null) _data["note"] = note;
    if (phoneNumber != null) _data["phoneNumber"] = phoneNumber;
    return _data;
  }

  SessionModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hour = json["hour"];
    date = json["date"];
    name = json["name"];
    addedBy = json["addedBy"];
    count = json["count"];
    income = json["income"];
    video = json["video"];
    gameId = json["gameId"];
    extra = json.containsKey("extra") ? json["extra"] : null;
    discount = json.containsKey("discount") ? json["discount"] : null;
    note = json.containsKey("note") ? json["note"] : null;
    phoneNumber = json.containsKey("phoneNumber") ? json["phoneNumber"] : null;
  }
}
