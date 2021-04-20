import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/entity/backup.dart';
import 'package:go_for_it/entity/bean.dart';
import 'package:go_for_it/entity/step.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/common.dart';
import 'package:go_for_it/service/backup.dart';
import 'package:go_for_it/util/database_helper.dart';

///
/// 备份管理
///
abstract class BackupModel extends Model {
  // 是否第一次刷新
  bool _isBackupFirst = true;

  // 获取第一次刷新
  bool get isBackupFirst => _isBackupFirst;

  // 状态
  var _backupStatus = CommonStatus.LOADING;

  // 获取状态
  CommonStatus get backupStatus => _backupStatus;

  // 备份列表
  List<Backup> _backups = [];

  // 获取备份列表
  List<Backup> get backups => _backups;

  ///
  /// 刷新备份信息
  ///
  Future<void> refreshBackup(user, connectivityResult) async {
    _backupStatus = CommonStatus.LOADING;
    _isBackupFirst = false;
    _backups = [];
    notifyListeners();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        _backups = await BackupService.getBackupList(user);
        _backupStatus = CommonStatus.DONE;
      } catch (e) {
        _backupStatus = CommonStatus.ERROR;
        throw e;
      }
    } else {
      _backupStatus = CommonStatus.ERROR;
    }
    notifyListeners();
  }

  ///
  /// 备份数据
  ///
  Future<void> backupData(user, String name) async {
    try {
      List<Task> tasks = await DatabaseHelper().queryTask();
      List<Step> steps = await DatabaseHelper().queryStep();
      Backup backup = await BackupService.backup(
          user, name, jsonEncode(Bean(tasks, steps).toJson()));
      _backups.add(backup);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 恢复数据
  ///
  Future<void> recoveryData(user, backup) async {
    try {
      Backup b = await BackupService.getBackup(user, backup);
      Bean bean = Bean.fromJson(jsonDecode(b.backup));
      await DatabaseHelper().recovery(bean.tasks, bean.steps);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 删除数据
  ///
  Future<void> deleteBackup(user, backup) async {
    try {
      await BackupService.delete(user, backup);
      _backups.removeWhere((b) => b.id == backup.id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
