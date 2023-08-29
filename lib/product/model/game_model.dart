// ignore_for_file: non_constant_identifier_names

class GameModel {
  String id;
  String name;
  int person_fee;
  int person_fee_double;
  int video_fee;
  List hours;

  GameModel({
    required this.id,
    required this.name,
    required this.person_fee,
    required this.person_fee_double,
    required this.video_fee,
    required this.hours,
  });

  toJson() {
    return {
      "id": id,
      "name": name,
      "person_fee": person_fee,
      "person_fee_double": person_fee_double,
      "video_fee": video_fee,
      "hours": hours,
    };
  }

  toJsonWithoutId() {
    return {
      "name": name,
      "person_fee": person_fee,
      "person_fee_double": person_fee_double,
      "video_fee": video_fee,
      "hours": hours,
    };
  }

  @override
  operator ==(other) =>
      other is GameModel && other.id == id && other.hashCode == hashCode;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GameModel{id: $id, name: $name, person_fee: $person_fee, person_fee_double: $person_fee_double, video_fee: $video_fee, hours: $hours}';
  }
}
