import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/page/home.dart';
import 'package:go_for_it/ui/view/password_field.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/transition.dart';

///
/// 登录页面
///
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginStateState();
  }
}

class _LoginStateState extends State<LoginPage> {
  // 表单键
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 用户名输入框键
  final GlobalKey<FormFieldState> _usernameFieldKey =
      GlobalKey<FormFieldState>();

  // 密码输入框键
  final GlobalKey<FormFieldState> _password1FieldKey =
      GlobalKey<FormFieldState>();

  // 密码再次输入框键
  final GlobalKey<FormFieldState> _password2FieldKey =
      GlobalKey<FormFieldState>();

  // 是否验证
  var _autovalidateMode = AutovalidateMode.disabled;

  // 是否登录模式
  bool _isLogin = true;

  // 用户名
  String username = '';

  // 密码1
  String password1 = '';

  // 密码2
  String password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(Constant.login),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  key: _usernameFieldKey,
                  controller: username != ''
                      ? TextEditingController.fromValue(
                          TextEditingValue(text: username))
                      : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: Constant.pleaseInputUsername,
                    labelText: Constant.username,
                  ),
                  onSaved: (String? value) {
                    if (value != null) {
                      username = value;
                    }
                  },
                  validator: _validateUsername,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: PasswordField(
                  fieldKey: _password1FieldKey,
                  controller: password1.isNotEmpty
                      ? TextEditingController.fromValue(
                          TextEditingValue(text: password1))
                      : null,
                  hintText: Constant.pleaseInputPassword,
                  labelText: Constant.password,
                  onSaved: (String? value) {
                    if (value != null) {
                      password1 = value;
                    }
                  },
                  validator: _validatePassword,
                ),
              ),
              _isLogin
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(10.0),
                      child: PasswordField(
                        fieldKey: _password2FieldKey,
                        controller: password2.isNotEmpty
                            ? TextEditingController.fromValue(
                                TextEditingValue(text: password2))
                            : null,
                        hintText: Constant.pleaseInputPasswordAgain,
                        labelText: Constant.password,
                        onSaved: (String? value) {
                          if (value != null) {
                            password2 = value;
                          }
                        },
                        validator: _validatePassword,
                      ),
                    ),
              SizedBox(height: 15.0),
              ScopedModelDescendant<MainStateModel>(
                builder: (context, widget, model) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: _changeModel,
                        child: Text(
                            _isLogin ? Constant.register : Constant.login,
                            style:
                                TextStyle(color: model.themeData.primaryColor)),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _loginOrRegister(model);
                        },
                        child: Text(
                            _isLogin ? Constant.login : Constant.register,
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              model.themeData.primaryColor),
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 改变模式
  ///
  _changeModel() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  ///
  /// 登录或注册1
  ///
  _loginOrRegister(MainStateModel model) async {
    final form = _formKey.currentState!;
    form.save();
    if (!form.validate()) {
      _autovalidateMode = AutovalidateMode.always;
      Alert.errorBar(context, Constant.pleaseCheckInput);
    } else {
      if (model.connectivityResult == ConnectivityResult.none) {
        Alert.toast(Constant.noneConnectivity);
      } else {
        try {
          await model.loginOrRegister(username, password1, _isLogin);
          Transition.pushAndRemoveUntil(
              context, HomePage(), TransitionType.inFromBottom);
        } catch (e) {
          _autovalidateMode = AutovalidateMode.always;
          Alert.errorBarError(context, e);
        }
      }
    }
  }

  ///
  /// 验证用户名正确性
  ///
  String _validateUsername(String? value) {
    if (value != null && value.isEmpty) {
      return Constant.pleaseInputUsername;
    } else {
      return '';
    }
  }

  ///
  /// 验证密码正确性
  ///
  String _validatePassword(String? value) {
    if (value == null) {
      return '';
    }
    if (value.isEmpty) {
      return Constant.pleaseInputPassword;
    } else if (value.length < 6) {
      return Constant.passwordLengthNotEnough;
    } else if (!_isLogin && password1 != value) {
      return Constant.passwordNotEqual;
    } else {
      return '';
    }
  }
}
