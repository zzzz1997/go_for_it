import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

///
/// 用户实体类
///
@JsonSerializable()
class User {
  int id;
  String username;
  String avatar;
  int startDayOfWeek;
  int language;
  String token;
  int tokenTime;
  int createdTime;

  User(this.id, this.username, this.avatar, this.startDayOfWeek, this.language,
      this.token, this.tokenTime, this.createdTime);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
