import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/clock_flag.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/ui/view/importance_view.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 全屏弹窗
///
// ignore: must_be_immutable
class FullscreenDialog extends StatefulWidget {
  FullscreenDialog({@required this.task, @required this.type});

  // 任务对象
  final Task task;

  // 任务类型
  final int type;

  @override
  State<StatefulWidget> createState() {
    return _FullscreenDialogState();
  }
}

///
/// 全屏弹窗状态
///
class _FullscreenDialogState extends State<FullscreenDialog> {
  // 任务对象
  Task _task;

  @override
  void initState() {
    super.initState();

    _task = widget.task == null
        ? Task(0, 0, 0, '', 0, 0, 0, 0, 0)
        : Task.fromJson(widget.task.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_task.id == 0 ? Constant.newTask : Constant.editTask),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.check), onPressed: _onOkClick),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _task.type == 0
                            ? HalfCheckBox(
                                status: _task.status,
                                color: model.themeData.primaryColor,
                                onPressed: () {
                                  _changeTaskStatus(model.user.checkMode);
                                },
                              )
                            : ClockFlag(
                                clocked: _task.status == 0,
                                color: model.themeData.primaryColor,
                                onPressed: () {},
                              ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Text('日'),
                        ),
                        PopupMenuButton(
                          itemBuilder: _popupMenuBuilder,
                          child: ImportanceView(
                            importance: _task.importance,
                          ),
                          onSelected: _onImportanceSelected,
                        ),
                      ],
                    ),
                    TextField(
                      controller: TextEditingController(text: _task.name),
                      onChanged: _onNameChanged,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ///
  /// 弹窗菜单构造器
  ///
  List<PopupMenuItem> _popupMenuBuilder(context) {
    List<PopupMenuItem> entries = List(Constant.taskImportance.length);
    for (int i = 0; i < Constant.taskImportance.length; i++) {
      entries[i] = PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ImportanceView(
              importance: i,
            ),
            Text(Constant.taskImportance[i]),
          ],
        ),
        value: i,
      );
    }
    return entries;
  }

  ///
  /// 确定按钮点击事件
  ///
  _onOkClick() {}

  ///
  /// 更改任务状态
  ///
  _changeTaskStatus(int checkMode) {
    setState(() {
      if (_task.type == 0) {
        _task.status = (_task.status + 1 + (checkMode == 0 ? 1 : 0)) > 2
            ? 0
            : _task.status + 1 + (checkMode == 0 ? 1 : 0);
      } else {
        _task.status = (_task.status + 2) > 2 ? 0 : _task.status + 2;
      }
    });
  }

  ///
  /// 任务重要性修改事件
  ///
  _onImportanceSelected(importance) {
    setState(() {
      _task.importance = importance;
    });
  }

  ///
  /// 任务名称更改事件
  ///
  _onNameChanged(name) {
    setState(() {
      _task.name = name;
    });
  }
}
