import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/page/home.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/transition.dart';

///
/// 用户页面
///
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Constant.userCenter),
        ),
        body: ScopedModelDescendant<MainStateModel>(
            builder: (context, widget, model) {
          return model.user.isLogin
              ? ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        _changeAvatar(model);
                      },
                      title: Text(Constant.avatar),
                      trailing: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(model.user.avatar)),
                    ),
                    ListTile(
                      title: Text(Constant.username),
                      subtitle: Text(model.user.username),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          _exitLogin(context, model);
                        },
                        child: Text(
                          Constant.exitLogin,
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                )
              : Text(Constant.unknownArea);
        }));
  }

  ///
  /// 更改头像
  ///
  _changeAvatar(MainStateModel model) {
    if (model.connectivityResult == ConnectivityResult.none) {
      Alert.toast(Constant.noneConnectivity);
    } else {
      model.changeAvatar();
    }
  }

  ///
  /// 退出登录
  ///
  _exitLogin(BuildContext context, MainStateModel model) async {
    try {
      await model.exitLogin();
      Transition.pushAndRemoveUntil(
          context, HomePage(), TransitionType.inFromBottom);
    } catch (e) {
      Alert.errorBarError(context, e);
    }
  }
}
