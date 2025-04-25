import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/test_result.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'multiplication_table.db');
    // print('Initializing database at $path'); // Commented out
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE test_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            completedTests INTEGER,
            accuracy REAL,
            correctAnswers INTEGER,
            wrongAnswers INTEGER,
            complexity TEXT,
            timestamp TEXT,
            answers TEXT
          )
        ''');
        // print('Database created'); // Commented out
      },
    );
  }

  Future<void> insertTestResult(TestResult result) async {
    final db = await database;
    await db.insert('test_results', result.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    // print('Inserted test result: ${result.toMap()}'); // Commented out
  }

  Future<List<TestResult>> getTestResults() async {
    final db = await database;
    final maps = await db.query('test_results');
    return maps.map((map) => TestResult.fromMap(map)).toList();
  }
}