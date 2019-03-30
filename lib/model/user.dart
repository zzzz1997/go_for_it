import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/user.dart';

///
/// 用户管理
///
abstract class UserModel extends Model {

  // 用户
  User _user;

  // 获取用户
  User get user => _user;

  factory UserModel._() => null;

  initUser() {
    Random random = Random();
    _user = User(0, '', random.nextInt(7) + 1, random.nextInt(2));
  }
}