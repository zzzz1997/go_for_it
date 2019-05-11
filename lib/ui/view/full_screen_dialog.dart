import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/clock_flag.dart';
import 'package:go_for_it/ui/view/date_picker.dart';
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

  // 名称控制器
  TextEditingController _nameController;

  // 名称控制器
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _task = widget.task == null
        ? Task(0, 0, 0, '', '', 0, 0, 0, 0, 0)
        : Task.fromJson(widget.task.toJson());
    _nameController = TextEditingController(text: _task.name);
    _descriptionController = TextEditingController(text: _task.description);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, child, model) {
        DateTime startTime =
            DateTime.fromMillisecondsSinceEpoch(_task.startTime * 1000);
        DateTime endTime =
            DateTime.fromMillisecondsSinceEpoch(_task.endTime * 1000);
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
                          child: InkResponse(
                            onTap: () {
                              _onTimeTap(model);
                            },
                            child: Text(
                                '${formatDate(startTime, startTime.year == model.today.year ? [
                                    m,
                                    '月',
                                    d,
                                    '日'
                                  ] : [
                                    yyyy,
                                    '年',
                                    m,
                                    '月',
                                    d,
                                    '日'
                                  ])}${_task.type == 1 ? '至${formatDate(endTime, startTime.year == model.today.year ? [m, '月', d, '日'] : [yyyy, '年', m, '月', d, '日'])}' : ''}'),
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: _popupMenuBuilder,
                          child: ImportanceView(
                            importance: _task.importance,
                          ),
                          onSelected: _onImportanceSelected,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: _onTypeTap,
                          child: SvgPicture.asset(
                            Constant.tabSVGs[_task.type == 0 ? 1 : 0],
                            width: 24.0,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: Constant.thing,
                        labelText: Constant.thing,
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: Constant.description,
                        alignLabelWithHint: true,
                        labelText: Constant.description,
                      ),
                    ),
                    InkResponse(
                      onTap: _onLabelTap,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset(
                            Constant.labelSvg,
                            width: 24.0,
                          ),
                        ),
                      ),
                    )
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
  /// 时间点击事件
  ///
  _onTimeTap(MainStateModel model) async {
    List<DateTime> dateTimes = await DatePicker.showPicker(
        context,
        DateTime.fromMillisecondsSinceEpoch(_task.startTime * 1000),
        DateTime.fromMillisecondsSinceEpoch(_task.endTime * 1000),
        _task.type == 0
            ? DatePickerSelectMode.DATE
            : DatePickerSelectMode.RANGE,
        model.user.language,
        model.user.startDayOfWeek);
    if (dateTimes != null && dateTimes.length == 2) {
      setState(() {
        _task.startTime = dateTimes[0].millisecondsSinceEpoch ~/ 1000;
        _task.endTime = dateTimes[1].millisecondsSinceEpoch ~/ 1000;
      });
    }
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
  /// 任务类型更改
  ///
  _onTypeTap() {
    setState(() {
      _task.type = _task.type == 0 ? 1 : 0;
    });
  }

  ///
  /// 标签点击事件
  ///
  _onLabelTap() {

  }
}
