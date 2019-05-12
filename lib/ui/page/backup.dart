import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:go_for_it/entity/backup.dart';
import 'package:go_for_it/model/common.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/tips_view.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';

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
                  _newBackup(context, model);
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
                                    return _buildBackup(model.backups[index]);
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
  Widget _buildBackup(Backup backup) {
    return ListTile(
      title: Text(backup.name),
      // todo 操作区
    );
  }

  ///
  /// 新建备份
  ///
  _newBackup(BuildContext context, MainStateModel model) {
    Alert.showConfirm(context, Constant.newBackup, () async {
      if (model.connectivityResult == ConnectivityResult.none) {
        Alert.toast(Constant.noneConnectivity);
      } else {
        try {
          String name =
              '备份${formatDate(DateTime.now(), [yy, mm, dd, hh, nn, ss])}';
          await model.backupData(model.user, name);
          Alert.successBar(context, Constant.backupSuccess);
        } catch (e) {
          Alert.errorBarError(context, e);
        }
      }
    });
  }
}
