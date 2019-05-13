import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:go_for_it/entity/user.dart';
import 'package:go_for_it/entity/step.dart';
import 'package:go_for_it/entity/task.dart';
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
    await db.execute('''
    CREATE TABLE User (
      id int(10) NOT NULL,
      username varchar(20) NOT NULL DEFAULT 'unnaming',
      avatar varchar(255) NOT NULL DEFAULT 'unavataring',
      language tinyint(3) NOT NULL DEFAULT '0',
      startDayOfWeek tinyint(3) NOT NULL DEFAULT '6',
      checkMode tinyint(3) NOT NULL DEFAULT '0',
      token varchar(255) NOT NULL DEFAULT '',
      tokenTime int(10) NOT NULL DEFAULT 0,
      createdTime int(10) NOT NULL,
      PRIMARY KEY (`id`)
    );
    ''');
    await db.execute('''
    CREATE TABLE Task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type tinyint(3) NOT NULL DEFAULT '0',
      classification tinyint(4) DEFAULT '0',
      name varchar(50) NOT NULL,
      description varchar(255) NOT NULL,
      importance tinyint(3) NOT NULL DEFAULT '0',
      status tinyint(3) NOT NULL DEFAULT '0',
      startTime int(10) NOT NULL,
      endTime int(10) NOT NULL,
      createdTime int(10) NOT NULL
    );
    ''');
    await db.execute('''
     CREATE TABLE Step (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskId int(10) NOT NULL,
      targetTime int(10) NOT NULL,
      createdTime int(10) NOT NULL
    );
    ''');
    await db.execute('''
    INSERT INTO `User` (id, createdTime) VALUES (0, ${DateTime.now().millisecondsSinceEpoch ~/ 1000});
    ''');
  }

  ///
  /// 查询用户
  ///
  Future<User> getUser() async {
    Database dbClient = await db;
    return User.fromJson((await dbClient.query('User'))[0]);
  }

  ///
  /// 更新用户信息
  ///
  Future<int> updateUser(User user) async {
    Database dbClient = await db;
    return await dbClient.update('User', user.toJson());
  }

  ///
  /// 获取任务列表
  ///
  Future<List<Task>> queryTask() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> tasks = await dbClient.query('Task');
    return tasks.map((d) => Task.fromJson(d)).toList();
  }

  ///
  /// 获取普通任务时间列表
  ///
  Future<List<int>> queryTimeTaskTimeList() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query('Task',
        columns: ['startTime'],
        where: 'type = ?',
        whereArgs: [0]);
    return list.map((m) => m['startTime'] as int).toList();
  }

  ///
  /// 获取某日普通任务列表
  ///
  Future<List<Task>> queryTimeTask(DateTime dateTime) async {
    Database dbClient = await db;
    List<Map<String, dynamic>> tasks = await dbClient.query('Task',
        where: 'type = ? and startTime = ?',
        whereArgs: [0, dateTime.millisecondsSinceEpoch ~/ 1000]);
    return tasks.map((d) => Task.fromJson(d)).toList();
  }

  ///
  /// 获取打卡任务列表
  ///
  Future<List<Task>> queryClockTask() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> tasks =
        await dbClient.query('Task', where: 'type = ?', whereArgs: [1]);
    return tasks.map((d) => Task.fromJson(d)).toList();
  }

  ///
  /// 获取打卡足迹列表
  ///
  Future<List<Step>> queryStep() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> steps = await dbClient.query('Step');
    return steps.map((d) => Step.fromJson(d)).toList();
  }

  ///
  /// 添加任务信息
  ///
  Future<int> insertTask(Task task) async {
    Database dbClient = await db;
    Map<String, dynamic> map = task.toJson();
    map.remove('id');
    return await dbClient.insert('Task', map);
  }

  ///
  /// 更新任务信息
  ///
  Future<int> updateTask(Task task) async {
    Database dbClient = await db;
    Map<String, dynamic> map = task.toJson();
    map.remove('id');
    return await dbClient
        .update('Task', map, where: 'id = ?', whereArgs: [task.id]);
  }

  ///
  /// 删除任务
  ///
  Future<int> deleteTask(Task task) async {
    Database dbClient = await db;
    return await dbClient.delete('Task', where: 'id = ?', whereArgs: [task.id]);
  }

  ///
  /// 插入打卡足迹
  ///
  Future<int> insertStep(Step step) async {
    Database dbClient = await db;
    Map<String, dynamic> map = step.toJson();
    map.remove('id');
    return await dbClient.insert('Step', map);
  }

  ///
  /// 删除打卡足迹
  ///
  Future<int> deleteStep(Step step) async {
    Database dbClient = await db;
    return await dbClient.delete('Step', where: 'id = ?', whereArgs: [step.id]);
  }

  ///
  /// 恢复数据
  ///
  Future<bool> recovery(List<Task> tasks, List<Step> steps) async {
    Database dbClient = await db;
    await dbClient.execute('''
    delete from Task;
    ''');
    await dbClient.execute('''
    update sqlite_sequence SET seq = 0 where name = 'Task';
    ''');
    for (Task task in tasks) {
      await dbClient.insert('Task', task.toJson());
    }
    await dbClient.execute('''
    delete from Step;
    ''');
    await dbClient.execute('''
    update sqlite_sequence SET seq = 0 where name = 'Step';
    ''');
    for (Step step in steps) {
      await dbClient.insert('Step', step.toJson());
    }
    return true;
  }

  ///
  /// 关闭数据库
  ///
  Future<void> close() async {
    Database dbClient = await db;
    return dbClient.close();
  }
}
