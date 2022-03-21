import 'package:eisenhower/task.dart';
import 'dart:math';

class TaskManager {
  TaskManager();

  final List<Task> _list = [];

  List<Task> get doIt =>
      _list.where((element) => element.type == Type.doIt).toList();
  List<Task> get delegate =>
      _list.where((element) => element.type == Type.delegate).toList();
  List<Task> get decide =>
      _list.where((element) => element.type == Type.decide).toList();
  List<Task> get delete =>
      _list.where((element) => element.type == Type.delete).toList();

  Task _createTask(title, desc, type) {
    final Task task = Task(title, desc, type);
    return task;
  }

  void addTask(title, desc, type) {
    final task = _createTask(title, desc, type);
    _list.add(task);
    print('Task added for: ' + title + " " + desc);
  }

  void deleteTask(task) {
    _list.remove(task);
  }

  void changeTask(task, type) {
    _list[task] = task.copyWith(type: type);
  }
}
