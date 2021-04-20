import 'package:dio/dio.dart';
import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/service/api.dart';
import 'package:image_picker/image_picker.dart';

///
/// 用户服务
///
class UserService {
  ///
  /// 用户登录或注册
  ///
  static Future<User> loginOrRegister(username, password, isLogin) async {
    try {
      Map<String, dynamic> _data =
          await Api.post('/user/${isLogin ? 'login' : 'register'}', data: {
        'username': username,
        'password': password,
      });
      return User.fromJson(_data);
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 上传头像
  ///
  static Future<String> avatar(User user, PickedFile avatar) async {
    try {
      return await Api.post('/user/avatar',
          data: {
            'avatar':
                await MultipartFile.fromFile(avatar.path, filename: '1.png'),
          },
          token: user.token);
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 设置用户信息
  ///
  static Future<bool> set(User user) async {
    try {
      await Api.post('/user/set',
          data: {
            'language': user.language,
            'startDayOfWeek': user.startDayOfWeek,
            'checkMode': user.checkMode,
          },
          token: user.token);
      return true;
    } catch (e) {
      throw e;
    }
  }
}
