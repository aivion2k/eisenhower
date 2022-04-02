import 'dart:html';

import 'package:eisenhower/task.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'boxes.dart';

class TaskManager {
  static final TaskManager _manager = TaskManager._internal();

  factory TaskManager() {
    return _manager;
  }

  TaskManager._internal();

  List<Task> _list = [];

  List<Task> get doIt =>
      _list.where((element) => element.type == TaskType.doIt).toList();
  List<Task> get delegate =>
      _list.where((element) => element.type == TaskType.delegate).toList();
  List<Task> get decide =>
      _list.where((element) => element.type == TaskType.decide).toList();
  List<Task> get delete =>
      _list.where((element) => element.type == TaskType.delete).toList();

  Task _createTask(title, desc, type) {
    final Task task = Task(title, desc, type);
    return task;
  }

  void addTask(title, desc, type) {
    final task = _createTask(title, desc, type);
    final box = Hive.box<Task>('tasks');
    box.add(task);
    _list.add(task);
    var task1 = box.get(0);

    print('Task added for: ' + task1!.desc + " " + desc);
  }

  void updateList() {
    final box = Hive.box<Task>('tasks');
    if (box.isNotEmpty) {
      var it = box.values.iterator;
      while (it.moveNext()) {
        _list.add(
            _createTask(it.current.title, it.current.desc, it.current.type));
      }
    }
  }

  void deleteTask(task) {
    _list.remove(task);
  }

  void changeTask(task, type) {
    _list[task] = task.copyWith(type: type);
  }
}
