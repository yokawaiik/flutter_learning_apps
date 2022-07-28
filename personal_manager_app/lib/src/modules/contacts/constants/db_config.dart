
const int dataBaseVersion = 1;

const String table = "contacts";

const String dataBaseName = "contacts";

const String id = "id";
const String pathToImage = "pathToImage";
const String name = "name";
const String phone = "phone";
const String email = "email";
const String birthdayDate = "birthdayDate";

String createTableTasksSql() {
  return '''
        CREATE TABLE IF NOT EXISTS ${table} (
          ${id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${pathToImage} TEXT,
          ${name} TEXT,
          ${phone} TEXT,
          ${email} TEXT,
          ${birthdayDate} INT
        )
      ''';
}
