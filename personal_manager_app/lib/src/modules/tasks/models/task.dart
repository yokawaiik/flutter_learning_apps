import 'package:intl/intl.dart';

class Task {
  int? id;
  String? description;
  DateTime? dueDate;
  late bool isCompleted;

  Task({
    this.id,
    this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  String get date {
    if (dueDate == null) return "Due date";

    return DateFormat.yMMMMd().format(dueDate!);
  }

  int get completeStatus {
    return isCompleted ? 1 : 0;
  }

  @override
  String toString() {
    return "$id $description $dueDate $isCompleted";
  }

  Task.fromMap(data) {
    id = data["id"];
    description = data["description"];
    dueDate = data["dueDate"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(data["dueDate"]);
    isCompleted = data["isCompleted"] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "dueDate": dueDate?.millisecondsSinceEpoch,
      "isCompleted": isCompleted ? 1 : 0,
    };
  }
}
