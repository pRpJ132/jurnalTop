import 'package:my_app/models/day_lessons.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleHistoryDatabase {
  static final ScheduleHistoryDatabase _instance = ScheduleHistoryDatabase._internal();
  factory ScheduleHistoryDatabase() => _instance;
  ScheduleHistoryDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'schedule-history-0-0-4-test.db');

    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE schedule_history (
            date TEXT,
            lesson INTEGER,
            started_at TEXT,
            finished_at TEXT,
            subject_name TEXT,
            teacher_name TEXT,
            room_name TEXT,
            UNIQUE(date, lesson)
          )
        ''');
      },
    );
  }

  Future<void> saveScheduleHistory(List<DayLessons> dt) async {
    final db = await database;

    for (DayLessons product in dt) {
      await db.insert(
        'schedule_history', 
        {
          'date': product.date,
          'lesson': product.lesson,
          'started_at': product.startedAt,
          'finished_at': product.finishedAt,
          'subject_name': product.subjectName,
          'teacher_name': product.teacherName,
          'room_name': product.roomName
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<DayLessons>> getScheduleHistory(String date) async {
    final db = await database;

    final month = date.substring(0, 7);

    final scheduleHistoryDB = await db.query(
      'schedule_history',
      where: 'date LIKE ?',
      whereArgs: ['$month%'],
    );

    return scheduleHistoryDB
        .map((schedule) => DayLessons.fromJson(schedule))
        .toList();
  }

  Future<void> clearScheduleHistory() async {
    final db = await database;
    await db.delete('schedule_history');
  }
}