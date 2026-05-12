import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agenda_nusantara.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        due_date TEXT NOT NULL,
        category TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE credentials (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.insert('credentials', {
      'id': 1,
      'username': 'user',
      'password': 'user',
    });
  }

  // ─── TASKS ───────────────────────────────────────────────

  Future<int> insertTask(TaskModel task) async {
    final database = await db;
    return await database.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final database = await db;
    final maps = await database.query('tasks', orderBy: 'due_date ASC');
    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  Future<void> toggleTask(int id, bool isDone) async {
    final database = await db;
    await database.update(
      'tasks',
      {
        'is_done': isDone ? 1 : 0,
        'completed_at': isDone ? DateTime.now().toIso8601String() : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, int>> getStats() async {
    final database = await db;
    final done = Sqflite.firstIntValue(
          await database
              .rawQuery('SELECT COUNT(*) FROM tasks WHERE is_done = 1'),
        ) ??
        0;
    final notDone = Sqflite.firstIntValue(
          await database
              .rawQuery('SELECT COUNT(*) FROM tasks WHERE is_done = 0'),
        ) ??
        0;
    return {'done': done, 'notDone': notDone};
  }

  /// Returns last 7 days with count of completed tasks per day.
  /// List of {'day': 'YYYY-MM-DD', 'count': N}
  Future<List<Map<String, dynamic>>> getDonePerDay() async {
    final database = await db;
    final result = await database.rawQuery('''
      SELECT date(completed_at) as day, COUNT(*) as count
      FROM tasks
      WHERE is_done = 1 AND completed_at IS NOT NULL
      GROUP BY date(completed_at)
      ORDER BY day DESC
      LIMIT 7
    ''');
    return result;
  }

  // ─── CREDENTIALS ─────────────────────────────────────────

  Future<Map<String, dynamic>?> getCredentials() async {
    final database = await db;
    final result = await database.query('credentials', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updatePassword(String newPassword) async {
    final database = await db;
    await database.update(
      'credentials',
      {'password': newPassword},
      where: 'id = 1',
    );
  }
}
