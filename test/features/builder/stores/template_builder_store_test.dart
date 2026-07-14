import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/builder/stores/template_builder_store.dart';
import 'package:mobile/features/builder/data/template_repository.dart';
import 'package:mobile/shared/models/exercise_model.dart';
import 'package:mobile/shared/models/template_model.dart';

class MockTemplateRepository extends Mock implements TemplateRepository {}
class FakeTemplateModel extends Fake implements TemplateModel {}

void main() {
  late TemplateBuilderStore store;
  late MockTemplateRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTemplateModel());
  });

  setUp(() {
    mockRepository = MockTemplateRepository();
    store = TemplateBuilderStore(mockRepository);
  });

  test('Deve adicionar e remover um exercicio no builder', () {
    final exercise = ExerciseModel(name: 'Supino', muscleGroup: 'Peito');
    
    store.addExercise(exercise);
    expect(store.state.length, 1);
    
    store.removeExercise(0);
    expect(store.state.isEmpty, true);
  });

  test('Deve reordenar exercicios corretamente (simulando Drag and Drop)', () {
    store.addExercise(ExerciseModel(name: 'Ex1', muscleGroup: 'A'));
    store.addExercise(ExerciseModel(name: 'Ex2', muscleGroup: 'B'));
    store.addExercise(ExerciseModel(name: 'Ex3', muscleGroup: 'C'));
    
    store.reorderExercises(0, 3);
    
    expect(store.state[0].name, 'Ex2');
    expect(store.state[1].name, 'Ex3');
    expect(store.state[2].name, 'Ex1');
  });

  test('Deve salvar o template com sucesso e limpar o estado visual', () async {
    store.addExercise(ExerciseModel(name: 'Ex1', muscleGroup: 'A'));
    when(() => mockRepository.saveTemplate(any())).thenAnswer((_) async => 1);

    await store.saveTemplate('Treino A');

    expect(store.state.isEmpty, true);
    verify(() => mockRepository.saveTemplate(any())).called(1);
  });
}
