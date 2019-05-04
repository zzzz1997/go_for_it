import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/service/api.dart';

///
/// 用户服务
///
class UserService {

  ///
  /// 用户登录或注册
  ///
  static Future<User> loginOrRegister(username, password, isLogin) async {
    try {
      Map<String, dynamic> _data = await Api.post('/user/${isLogin ? 'login' : 'register'}', data: {
        'username': username,
        'password': password,
      });
      return User.fromJson(_data);
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 设置用户信息
  ///
  static Future<bool> set(User user) async {
    try {
      await Api.post('/user/set', data: {
        'language': user.language,
        'startDayOfWeek': user.startDayOfWeek,
      }, token: user.token);
      return true;
    } catch (e) {
      throw e;
    }
  }
}