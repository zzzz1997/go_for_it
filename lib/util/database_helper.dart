import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 数据库工具
///
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  DatabaseHelper.internal();

  ///
  /// 获取数据库对象
  ///
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  ///
  /// 初始化数据库
  ///
  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), '${Constant.dbName}.db');
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  ///
  /// 创建数据库
  ///
  _onCreate(Database db, int version) async {
    await db.execute('');
  }

  ///
  /// 关闭数据库
  ///
  Future<void> close() async {
    Database dbClient = await db;
    return dbClient.close();
  }
}