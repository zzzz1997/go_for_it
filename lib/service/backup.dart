import 'package:go_for_it/entity/backup.dart';
import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/service/api.dart';

///
/// 备份服务
///
class BackupService {
  ///
  /// 获取单个备份
  ///
  static Future<Backup> getBackup(User user, Backup backup) async {
    try {
      return Backup.fromJson(
          await Api.get('/backup/detail/${backup.id}', token: user.token));
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 获取备份列表
  ///
  static Future<List<Backup>> getBackupList(User user) async {
    try {
      final List<dynamic> data =
          await Api.get('/backup/list', token: user.token);
      return data.map((d) => Backup.fromJson(d)).toList();
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 备份数据
  ///
  static Future<Backup> backup(User user, String name, String backup) async {
    try {
      return Backup.fromJson(await Api.post('/backup/backup',
          data: {
            'name': name,
            'backup': backup,
          },
          token: user.token));
    } catch (e) {
      throw e;
    }
  }

  ///
  /// 删除备份
  ///
  static Future<bool> delete(User user, Backup backup) async {
    try {
      return await Api.post('/backup/delete',
          data: {
            'id': backup.id,
          },
          token: user.token);
    } catch (e) {
      throw e;
    }
  }
}
