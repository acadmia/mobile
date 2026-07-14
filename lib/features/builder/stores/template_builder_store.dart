import 'package:flutter_triple/flutter_triple.dart';
import '../../../shared/models/exercise_model.dart';
import '../../../shared/models/template_model.dart';
import '../data/template_repository.dart';

class TemplateBuilderStore extends Store<List<ExerciseModel>> {
  final TemplateRepository _repository;

  TemplateBuilderStore(this._repository) : super([]);

  void addExercise(ExerciseModel exercise) {
    final newList = List<ExerciseModel>.from(state)..add(exercise);
    update(newList);
  }

  void removeExercise(int index) {
    final newList = List<ExerciseModel>.from(state)..removeAt(index);
    update(newList);
  }

  void reorderExercises(int oldIndex, int newIndex) {
    final newList = List<ExerciseModel>.from(state);
    
    // Regra do ReorderableListView do Flutter: se movemos de cima pra baixo,
    // o newIndex vem acrescido de 1, precisando ser ajustado.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    
    update(newList);
  }

  Future<void> saveTemplate(String name) async {
    if (name.trim().isEmpty || state.isEmpty) return;

    setLoading(true);
    try {
      final template = TemplateModel(name: name.trim(), exercises: state);
      await _repository.saveTemplate(template);
      update([]); 
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }
}
