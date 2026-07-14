import 'package:sqflite/sqflite.dart';
import '../../../shared/models/exercise_model.dart';
import '../../../core/database/database_helper.dart';

class CatalogRepository {
  final DatabaseHelper _dbHelper;

  CatalogRepository(this._dbHelper);

  Future<List<ExerciseModel>> getAllExercises() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      orderBy: 'name ASC',
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).toList();
  }

  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String group) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'muscle_group = ?',
      whereArgs: [group],
      orderBy: 'name ASC',
    );

    return maps.map((map) => ExerciseModel.fromMap(map)).toList();
  }

  Future<int> saveCustomExercise(ExerciseModel exercise) async {
    final db = await _dbHelper.database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<List<String>> getDistinctMuscleGroups() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT muscle_group FROM exercises ORDER BY muscle_group ASC');
    return maps.map((map) => map['muscle_group'] as String).toList();
  }
}
