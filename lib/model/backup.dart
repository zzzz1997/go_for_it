import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/entity/backup.dart';
import 'package:go_for_it/model/common.dart';
import 'package:go_for_it/service/backup.dart';

///
/// 备份管理
///
abstract class BackupModel extends Model {

  // 是否第一次刷新
  bool _isBackupFirst = true;

  // 获取第一次刷新
  bool get isBackupFirst => _isBackupFirst;

  // 状态
  CommonStatus _backupStatus;

  // 获取状态
  CommonStatus get backupStatus => _backupStatus;

  // 备份列表
  List<Backup> _backups;

  // 获取备份列表
  List<Backup> get backups => _backups;

  factory BackupModel._() => null;

  ///
  /// 刷新备份信息
  ///
  Future<void> refreshBackup(user, connectivityResult) async {
    _backupStatus = CommonStatus.LOADING;
    _isBackupFirst = false;
    _backups = null;
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
  Future<void> backupData() async {

  }
}