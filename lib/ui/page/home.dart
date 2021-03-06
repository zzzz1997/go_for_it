import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/fragment/clock.dart';
import 'package:go_for_it/ui/fragment/time.dart';
import 'package:go_for_it/ui/fragment/todo.dart';
import 'package:go_for_it/ui/page/backup.dart';
import 'package:go_for_it/ui/page/login.dart';
import 'package:go_for_it/ui/page/setting.dart';
import 'package:go_for_it/ui/page/user.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/modal.dart';
import 'package:go_for_it/util/transition.dart';

///
/// 主页面
///
class HomePage extends StatelessWidget {
  // swiper控制器
  final SwiperController _swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
        builder: (context, widget, model) {
      // 底部导航列表
      List<BottomNavigationBarItem> _items = [];
      for (int i = 0; i < Constant.tabTexts.length; i++) {
        _items.add(BottomNavigationBarItem(
          icon: _getIcon(model, i),
          label: Constant.tabTexts[i],
        ));
      }
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('${model.date.month}/${model.date.day}'),
          actions: <Widget>[
            model.currentIndex != 2 && model.date != model.today
                ? GestureDetector(
                    onTap: () {
                      model.updateDate(model.today);
                    },
                    child: SvgPicture.asset(
                      Constant.todaySVG,
                      width: 24.0,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        body: Swiper(
          controller: _swiperController,
          itemCount: _items.length,
          itemBuilder: _buildItems,
          onIndexChanged: (int index) {
            model.changePage(index);
          },
          loop: false,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: model.currentIndex,
          onTap: (int index) {
            _onBarTap(model, index);
          },
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _onUserTop(context, model);
                },
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: model.user.isLogin
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(model.user.avatar),
                        )
                      : SvgPicture.asset(Constant.defaultAvatarSVG),
                  accountName: Text(model.user.isLogin
                      ? model.user.username
                      : Constant.loginOrRegister),
                  accountEmail: Text(Constant.appTag),
                ),
              ),
              ClipRect(
                  child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      _onSettingTap(context);
                    },
                    leading: Icon(Icons.settings),
                    title: Text(Constant.setting),
                  ),
                  ListTile(
                    onTap: () {
                      _onBackupAndRecoveryTap(context, model);
                    },
                    leading: Icon(Icons.cloud_queue),
                    title: Text(Constant.backupAndRecovery),
                  ),
                  ListTile(
                    onTap: () {
                      _onAboutTap(context);
                    },
                    leading: Icon(Icons.error_outline),
                    title: Text(Constant.about),
                  )
                ],
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddModal(context, model);
          },
          backgroundColor: model.themeData.primaryColor,
          child: Icon(Icons.add),
        ),
      );
    });
  }

  ///
  /// 获取图标
  ///
  _getIcon(MainStateModel model, int index) {
    return SvgPicture.asset(
      Constant.tabSVGs[index],
      color: index == model.currentIndex
          ? model.themeData.primaryColor
          : Colors.grey,
      width: 32.0,
    );
  }

  ///
  /// 构建碎片布局
  ///
  Widget _buildItems(BuildContext context, int index) {
    switch (index) {
      case 0:
        return ClockFragment();
      case 1:
        return TimeFragment();
      case 2:
        return TodoFragment();
      default:
        return Text(Constant.unknownArea);
    }
  }

  ///
  /// 底部导航栏点击事件
  ///
  _onBarTap(MainStateModel model, int index) {
    _swiperController.move(index);
    model.changePage(index);
  }

  ///
  /// 显示新建模态框
  ///
  _showAddModal(BuildContext context, MainStateModel model) {
    ModalUtil.showTaskModal(
        context,
        Task(
            -1,
            model.currentIndex == 0 ? 1 : 0,
            0,
            '',
            '',
            0,
            0,
            model.date.millisecondsSinceEpoch ~/ 1000,
            model.date.add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
            0));
  }

  ///
  /// 用户信息按钮点击事件
  ///
  _onUserTop(BuildContext context, MainStateModel model) {
    if (model.user.isLogin) {
      Transition.push(context, UserPage(), TransitionType.inFromRight);
    } else {
      Transition.push(context, LoginPage(), TransitionType.inFromRight);
    }
  }

  ///
  /// 设置按钮点击事件
  ///
  _onSettingTap(BuildContext context) {
    Transition.push(context, SettingPage(), TransitionType.inFromRight);
  }

  ///
  /// 备份与恢复按钮点击事件
  ///
  _onBackupAndRecoveryTap(BuildContext context, MainStateModel model) {
    if (model.user.isLogin) {
      Transition.push(context, BackupPage(), TransitionType.inFromRight);
    } else {
      Transition.push(context, LoginPage(), TransitionType.inFromRight);
    }
  }

  ///
  /// 关于按钮点击事件
  ///
  _onAboutTap(BuildContext context) {
    Alert.showAbout(context);
  }
}
