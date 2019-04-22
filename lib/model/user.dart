import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/service/user.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/database_helper.dart';

///
/// 用户状态管理
///
abstract class UserModel extends Model {
  // 用户
  User _user = User(0, '', '', 6, 0, '', 0, 0);

  // 获取用户
  User get user => _user;

  factory UserModel._() => null;

  ///
  /// 初始化获取用户
  ///
  initUser() async {
    _user = await DatabaseHelper().getUser();
    notifyListeners();
  }

  ///
  /// 设置选择设置
  ///
  Future<void> setSelectSetting(setting, value) {
    if (setting == Constant.weekLanguage) {
      _user.language = value;
    } else {
      _user.startDayOfWeek = value + 1;
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
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
