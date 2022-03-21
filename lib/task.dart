enum Type { doIt, delegate, decide, delete }

class Task {
  Task(this.title, this.desc, this.type);

  final String title;
  final String desc;
  final Type type;

  Task copyWith({String? title, String? desc, Type? type}) {
    return Task(title ?? this.title, desc ?? this.desc, type ?? this.type);
  }
}
