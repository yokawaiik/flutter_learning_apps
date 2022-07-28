
const int dataBaseVersion = 1;

const String table = "appointments";

const String dataBaseName = "appointments";

const String id = "id";
const String title = "title";
const String description = "description";
const String apptDate = "apptDate";
const String apptTime = "apptTime";

String createTableTasksSql() {
  return '''
        CREATE TABLE IF NOT EXISTS ${table} (
          ${id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${title} TEXT,
          ${description} TEXT,
          ${apptDate} INT,
          ${apptTime} TEXT
        )
      ''';
}
