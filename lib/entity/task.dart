///
/// 任务实体类
///
abstract class Task {
  int id;
  String name;
  int importance;
  int startTime;
  int endTime;
  int createdTime;

  Task(this.id, this.name, this.importance, this.startTime, this.endTime,
      this.createdTime);
}
