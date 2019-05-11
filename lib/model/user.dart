import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/service/user.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/database_helper.dart';

///
/// 用户状态管理
///
abstract class UserModel extends Model {
  // 用户
  User _user = User(0, '', '', 0, 6, 0, '', 0, false, 0);

  // 获取用户
  User get user => _user;

  factory UserModel._() => null;

  ///
  /// 初始化获取用户
  ///
  initUser() async {
    _user = await DatabaseHelper().getUser();
    print(_user.toJson());
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 < _user.tokenTime) {
      _user.isLogin = true;
    }
    notifyListeners();
  }

  ///
  /// 设置选择设置
  ///
  Future<void> setSelectSetting(setting, value, connectivityResult) {
    switch (setting) {
      case Constant.weekLanguage:
        _user.language = value;
        break;
      case Constant.weekStart:
        _user.startDayOfWeek = value + 1;
        break;
      case Constant.checkMode:
        _user.checkMode = value;
        break;
      default:
        break;
    }
    DatabaseHelper().updateUser(_user);
    if (user.isLogin && connectivityResult != ConnectivityResult.none) {
      UserService.set(user);
    }
    notifyListeners();
    return null;
  }

  ///
  /// 用户登录或注册
  ///
  Future<void> loginOrRegister(username, password, isLogin) async {
    try {
      _user = await UserService.loginOrRegister(username, password, isLogin);
      await DatabaseHelper().updateUser(user);
      _user.isLogin = true;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 更换头像
  ///
  Future<void> changeAvatar() async {
    try {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      String avatar = await UserService.avatar(user, image);
      _user.avatar = avatar;
      await DatabaseHelper().updateUser(user);
      Alert.toast(Constant.changeAvatarSuccess);
      notifyListeners();
    } catch (e) {
      Alert.toast(Constant.changeAvatarFail);
    }
  }

  ///
  /// 退出登录
  ///
  Future<void> exitLogin() async {
    _user.tokenTime = 0;
    _user.isLogin = false;
    try {
      await DatabaseHelper().updateUser(_user);
    } catch (e) {
      throw e;
    }
  }
}
