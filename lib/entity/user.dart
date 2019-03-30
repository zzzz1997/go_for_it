import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

///
/// 用户实体类
///
@JsonSerializable()
class User {
  int id;
  String username;
  int startDayOfWeek;
  int language;

  User(this.id, this.username, this.startDayOfWeek, this.language);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
