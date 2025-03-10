import 'package:matrimony_application/utils/string_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Database db = await openDatabase(
            join(await getDatabasesPath(), MyDatabaseName),
            onCreate: (db, version)  async {
             await db.execute('''
                CREATE TABLE IF NOT EXISTS $Table_User ( 
                  $UserId INTEGER PRIMARY KEY AUTOINCREMENT,
                  $Name TEXT NOT NULL,
                  $Email TEXT NOT NULL,
                  $Mobile TEXT NOT NULL,
                  $DOB TEXT NOT NULL,
                  $City TEXT NOT NULL,
                  $Gender TEXT NOT NULL,
                  $Password TEXT NOT NULL,
                  $Hobbies TEXT,
                  $isFavourite INTEGER NOT NULL
                  );
                  ''');
             },

        onUpgrade: (db, oldVersion, newVersion) async {
              if(oldVersion < 2){
                addColumns(db);
              }
        },
        version: DB_Version,
        );

    return db;
  }

  void addColumns(Database db) async{
    await db.execute('ALTER TABLE $Table_User ADD COLUMN $AboutMe TEXT');
    await db.execute('ALTER TABLE $Table_User ADD COLUMN $Profession TEXT');
  }
}
