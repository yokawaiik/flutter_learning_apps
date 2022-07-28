
const int dataBaseVersion = 1;

const String table = "tasks";

const String dataBaseName = "tasks";

const String id = "id";
const String description = "description";
const String dueDate = "dueDate";
const String isCompleted = "isCompleted";

String createTableTasksSql() {
  return '''
        CREATE TABLE IF NOT EXISTS ${table} (
          ${id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${description} TEXT,
          ${dueDate} INTEGER,
          ${isCompleted} INTEGER
        )
      ''';
}
