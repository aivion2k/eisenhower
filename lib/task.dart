import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskType {
  @HiveField(0)
  doIt,
  @HiveField(1)
  delegate,
  @HiveField(2)
  decide,
  @HiveField(3)
  delete
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(this.title, this.desc, this.type);

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String desc;

  @HiveField(2)
  final TaskType type;

  Task copyWith({String? title, String? desc, TaskType? type}) {
    return Task(title ?? this.title, desc ?? this.desc, type ?? this.type);
  }
}
