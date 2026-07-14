import 'package:sqflite/sqflite.dart';
import '../../../shared/models/workout_session_model.dart';
import '../../../shared/models/workout_set_model.dart';
import '../../../core/database/database_helper.dart';

class WorkoutRepository {
  final DatabaseHelper _dbHelper;

  WorkoutRepository(this._dbHelper);

  Future<int> startSession(int? templateId) async {
    final db = await _dbHelper.database;
    final session = WorkoutSessionModel(
      templateId: templateId,
      startTime: DateTime.now(),
    );
    return await db.insert('workout_sessions', session.toMap());
  }

  Future<int> saveSet(WorkoutSetModel setModel) async {
    final db = await _dbHelper.database;
    return await db.insert('workout_sets', setModel.toMap());
  }

  Future<WorkoutSetModel?> getLastPerformanceForExercise(int exerciseId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'workout_sets',
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
      orderBy: 'completed_at DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return WorkoutSetModel.fromMap(result.first);
    }
    return null;
  }
}
