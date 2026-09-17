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
    if (dt.isEmpty) return;

    final db = await database;

    final firstDate = DateTime.parse(dt.first.date);
    final year = firstDate.year;
    final month = firstDate.month;

    final nextMonth = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    final nextMonthString =
        '${nextMonth.year.toString().padLeft(4, '0')}-'
        '${nextMonth.month.toString().padLeft(2, '0')}-01';

    final monthString =
        '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-01';

    await db.transaction((txn) async {
      await txn.delete(
        'schedule_history',
        where: 'date >= ? AND date < ?',
        whereArgs: [monthString, nextMonthString],
      );

      for (final lesson in dt) {
        await txn.insert(
          'schedule_history',
          {
            'date': lesson.date,
            'lesson': lesson.lesson,
            'started_at': lesson.startedAt,
            'finished_at': lesson.finishedAt,
            'subject_name': lesson.subjectName,
            'teacher_name': lesson.teacherName,
            'room_name': lesson.roomName,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
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