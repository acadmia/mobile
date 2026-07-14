class WorkoutSetModel {
  final int? id;
  final int sessionId;
  final int exerciseId;
  final double weight;
  final int reps;
  final DateTime completedAt;

  WorkoutSetModel({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.weight,
    required this.reps,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'weight': weight,
      'reps': reps,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  factory WorkoutSetModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSetModel(
      id: map['id'],
      sessionId: map['session_id'],
      exerciseId: map['exercise_id'],
      weight: (map['weight'] as num).toDouble(),
      reps: map['reps'],
      completedAt: DateTime.parse(map['completed_at']),
    );
  }
}
