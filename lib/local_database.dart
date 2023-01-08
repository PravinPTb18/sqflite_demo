import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/user_data.dart';

class LocalDatabase {
  /// defining database name
  static const _databaseName = "user_data.db";

  /// version of db
  static const _databaseVersion = 1;

  /// table name
  static const table = 'users_table';

  /// defining the names of columns
  static const columnId = 'id';
  static const columnFirstName = 'first_name';
  static const columnLastName = 'last_name';
  static const columnAddress = 'address';
  static const columnMobile = 'mobile';
  static const columnAge = 'age';

  /// making singleton class
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  /// creating reference of database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    /// initializing database if it accessed first time
    _database = await _initDatabase();
    return _database!;
  }

  /// here it will create the database in does not exist
  /// if it exist it will open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// here we will write the command to create database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnFirstName TEXT NOT NULL,
            $columnLastName TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,
            $columnMobile INTEGER NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
  }

  /// now we will create a function to insert the user data
  /// by this function it will insert the row in db

  Future<int> insertUserData(UserData userData) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'first_name': userData.firstName,
      'last_name': userData.lastName,
      'mobile': userData.mobile,
      'address': userData.address,
      'age': userData.age
    });
  }

  /// here it will return all the rows as a list , list with key-value of column as a map
  Future<List<Map<String, dynamic>>> getAllUserData() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  /// it is used to query the row to get the data based on arguments passed
  Future<List<Map<String, dynamic>>> getUserDataByName(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnFirstName LIKE '%$name%'");
  }

  /// here it will update values of the row
  Future<int> updateUserData(UserData userData) async {
    Database db = await instance.database;
    int id = userData.toMap()['id'];
    return await db.update(table, userData.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  /// to delete the entire row using an id which returns the number of rows affected
  Future<int> deleteUserData(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
