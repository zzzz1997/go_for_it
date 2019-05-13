import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:go_for_it/entity/backup.dart';
import 'package:go_for_it/model/common.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/page/home.dart';
import 'package:go_for_it/ui/view/tips_view.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/transition.dart';

///
/// 备份与恢复页面
///
class BackupPage extends StatelessWidget {
  // 刷新键
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.backupAndRecovery),
        automaticallyImplyLeading: true,
      ),
      body: ScopedModelDescendant<MainStateModel>(
        builder: (context, child, model) {
          if (model.isBackupFirst) {
            model.refreshBackup(model.user, model.connectivityResult);
          }
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(Constant.backupTips),
              ),
              RaisedButton(
                child: Text(Constant.backup,
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _onBackupPressed(context, model);
                },
                color: model.themeData.primaryColor,
                shape: StadiumBorder(),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(Constant.backupHistory),
              Divider(),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  child: model.backupStatus == CommonStatus.LOADING
                      ? TipsView(
                          view: SizedBox(
                            width: ScreenUtil.instance
                                .setWidth(Constant.width / 4),
                            height: ScreenUtil.instance
                                .setWidth(Constant.width / 4),
                            child: CircularProgressIndicator(),
                          ),
                          tips: Constant.loading,
                        )
                      : model.backupStatus == CommonStatus.DONE
                          ? model.backups.length == 0
                              ? TipsView(
                                  view: Icon(Icons.tag_faces,
                                      size: ScreenUtil.instance
                                          .setWidth(Constant.width / 3)),
                                  tips: Constant.noBackup,
                                  onTap: () {
                                    _refreshIndicatorKey.currentState.show();
                                  })
                              : ListView.builder(
                                  itemBuilder: (context, index) {
                                    return _buildBackup(
                                        context, model, model.backups[index]);
                                  },
                                  itemCount: model.backups.length,
                                )
                          : TipsView(
                              view: Icon(Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: ScreenUtil.instance
                                      .setWidth(Constant.width / 3)),
                              tips: Constant.loadError,
                              onTap: () {
                                _refreshIndicatorKey.currentState.show();
                              },
                            ),
                  onRefresh: () async {
                    await model.refreshBackup(
                        model.user, model.connectivityResult);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ///
  /// 备份列表构造器
  ///
  Widget _buildBackup(
      BuildContext context, MainStateModel model, Backup backup) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    backup.name,
                    style: model.themeData.textTheme.title,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          backup.createdTime * 1000),
                      [yy, '年', m, '月', d, '日', H, '时', n, '分', ss, '秒']))
                ],
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _onRecoveryPressed(context, model, backup);
                      },
                      child: Text(Constant.recovery),
                    ),
                    FlatButton(
                      onPressed: () {
                        _onDeletePressed(context, model, backup);
                      },
                      child: Text(Constant.delete),
                    )
                  ],
                ),
              ),
            ]));
  }

  ///
  /// 备份点击事件
  ///
  _onBackupPressed(BuildContext context, MainStateModel model) {
    Alert.showConfirm(context, Constant.newBackup, () async {
      if (model.connectivityResult == ConnectivityResult.none) {
        Alert.toast(Constant.noneConnectivity);
      } else {
        try {
          String name =
              '备份${formatDate(DateTime.now(), [yy, mm, dd, HH, nn, ss])}';
          await model.backupData(model.user, name);
          Alert.successBar(context, Constant.backupSuccess);
        } catch (e) {
          Alert.errorBarError(context, e);
        }
      }
    });
  }

  ///
  /// 恢复点击事件
  ///
  _onRecoveryPressed(
      BuildContext context, MainStateModel model, Backup backup) {
    Alert.showConfirm(context, Constant.recoveryData, () async {
      if (model.connectivityResult == ConnectivityResult.none) {
        Alert.toast(Constant.noneConnectivity);
      } else {
        try {
          await model.recoveryData(model.user, backup);
          Transition.pushAndRemoveUntil(
              context, HomePage(), TransitionType.inFromBottom);
        } catch (e) {
          Alert.errorBarError(context, e);
        }
      }
    });
  }

  ///
  /// 删除点击事件
  ///
  _onDeletePressed(BuildContext context, MainStateModel model, Backup backup) {
    Alert.showConfirm(context, Constant.deleteBackup, () async {
      if (model.connectivityResult == ConnectivityResult.none) {
        Alert.toast(Constant.noneConnectivity);
      } else {
        try {
          await model.deleteBackup(model.user, backup);
          Alert.successBar(context, Constant.deleteSuccess);
        } catch (e) {
          Alert.errorBarError(context, e);
        }
      }
    });
  }
}
