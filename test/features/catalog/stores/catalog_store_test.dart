import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/catalog/stores/catalog_store.dart';
import 'package:mobile/features/catalog/data/catalog_repository.dart';
import 'package:mobile/shared/models/exercise_model.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late CatalogStore store;
  late MockCatalogRepository mockRepository;

  setUp(() {
    mockRepository = MockCatalogRepository();
    store = CatalogStore(mockRepository);
  });

  test('Deve atualizar o state ao carregar exercicios com sucesso', () async {
    final mockData = [ExerciseModel(name: 'Supino', muscleGroup: 'Peito')];
    when(() => mockRepository.getAllExercises()).thenAnswer((_) async => mockData);

    await store.loadExercises();

    expect(store.state.length, 1);
    expect(store.state.first.name, 'Supino');
    verify(() => mockRepository.getAllExercises()).called(1);
  });

  test('Deve emitir Erro ao falhar na busca', () async {
    when(() => mockRepository.getAllExercises()).thenThrow(Exception('Falha no banco'));

    await store.loadExercises();

    expect(store.error, isA<Exception>());
  });
}
