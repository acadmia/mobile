import 'package:flutter_triple/flutter_triple.dart';
import '../../../shared/models/exercise_model.dart';
import '../data/catalog_repository.dart';

class CatalogStore extends Store<List<ExerciseModel>> {
  final CatalogRepository _repository;

  CatalogStore(this._repository) : super([]);

  Future<void> loadExercises() async {
    setLoading(true);
    try {
      final exercises = await _repository.getAllExercises();
      update(exercises);
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> filterByMuscleGroup(String group) async {
    setLoading(true);
    try {
      if (group.isEmpty || group.toLowerCase() == 'todos') {
        final exercises = await _repository.getAllExercises();
        update(exercises);
      } else {
        final exercises = await _repository.getExercisesByMuscleGroup(group);
        update(exercises);
      }
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
