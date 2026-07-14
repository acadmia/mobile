import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/shared/models/exercise_model.dart';

void main() {
  test('Deve converter de Map para ExerciseModel corretamente', () {
    final map = {
      'id': 1,
      'name': 'Supino',
      'muscle_group': 'Peito',
      'is_custom': 1,
    };

    final model = ExerciseModel.fromMap(map);

    expect(model.id, 1);
    expect(model.name, 'Supino');
    expect(model.isCustom, true);
  });

  test('Deve converter de ExerciseModel para Map corretamente', () {
    final model = ExerciseModel(
      id: 2,
      name: 'Puxada',
      muscleGroup: 'Costas',
      isCustom: false,
    );

    final map = model.toMap();

    expect(map['id'], 2);
    expect(map['is_custom'], 0);
  });
}
