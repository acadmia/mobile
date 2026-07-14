import 'package:flutter_triple/flutter_triple.dart';
import '../../../shared/models/workout_set_model.dart';
import '../data/workout_repository.dart';

class ActiveWorkoutState {
  final int? sessionId;
  final List<WorkoutSetModel> completedSets;

  ActiveWorkoutState({this.sessionId, this.completedSets = const []});

  ActiveWorkoutState copyWith({int? sessionId, List<WorkoutSetModel>? completedSets}) {
    return ActiveWorkoutState(
      sessionId: sessionId ?? this.sessionId,
      completedSets: completedSets ?? this.completedSets,
    );
  }
}

class ActiveWorkoutStore extends Store<ActiveWorkoutState> {
  final WorkoutRepository _repository;

  ActiveWorkoutStore(this._repository) : super(ActiveWorkoutState());

  Future<void> startWorkout(int? templateId) async {
    setLoading(true);
    try {
      final sessionId = await _repository.startSession(templateId);
      update(state.copyWith(sessionId: sessionId));
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> registerSet({
    required int exerciseId,
    required double weight,
    required int reps,
  }) async {
    if (state.sessionId == null) return;

    final newSet = WorkoutSetModel(
      sessionId: state.sessionId!,
      exerciseId: exerciseId,
      weight: weight,
      reps: reps,
      completedAt: DateTime.now(),
    );

    try {
      final id = await _repository.saveSet(newSet);
      final savedSet = WorkoutSetModel(
        id: id,
        sessionId: newSet.sessionId,
        exerciseId: newSet.exerciseId,
        weight: newSet.weight,
        reps: newSet.reps,
        completedAt: newSet.completedAt,
      );
      
      final updatedSets = List<WorkoutSetModel>.from(state.completedSets)..add(savedSet);
      update(state.copyWith(completedSets: updatedSets));
    } catch (e) {
      setError(e);
    }
  }
}
