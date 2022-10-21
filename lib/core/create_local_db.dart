import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseCreate {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'ko.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  Future<void> populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  _createChatTable(Database db) async {
    await db
        .execute(
          """CREATE TABLE chats(
            id TEXT PRIMARY KEY,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )""",
        )
        .then((_) => print('creating table chats...'))
        .catchError((e) => print('error creating chats table: $e'));
  }

  _createMessagesTable(Database db) async {
    print("done done");
    await db
        .execute("""
          CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id TEXT PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            contents TEXT NOT NULL,
            receipt TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            isImage TEXT NOT NULL,
            imageStatus TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )
      """)
        .then((_) => print('creating table messages'))
        .catchError((e) => print('error creating Messages table: $e'));
  }
}
